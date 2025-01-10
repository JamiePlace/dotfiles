import concurrent.futures
import logging
import os
import shutil
import time
from typing import Dict, List, Optional, Tuple

import boto3
from botocore.client import Config
from botocore.exceptions import ClientError
from tqdm import tqdm


class S3Concurrent:
    """Class for concurrent operations with AWS S3."""

    def __init__(self, profile: Optional[str] = None, region: Optional[str] = None) -> None:
        """
        Initialize the S3Concurrent class.

        Args:
            profile (Optional[str]): AWS profile name.
            region (Optional[str]): AWS region name.
        """
        self.profile = profile
        self.region = region

        if profile and region:
            session = boto3.Session(profile_name=profile, region_name=region)
            self.s3_client = session.client("s3", config=Config(signature_version="s3v4"))
            self.s3_resource = session.resource("s3", config=Config(signature_version="s3v4"))
        else:
            self.s3_client = boto3.client("s3")
            self.s3_resource = boto3.resource("s3")

        logging.info("S3Concurrent initialized.")

    @staticmethod
    def make_clean_dir(path: str) -> None:
        """
        Clear and recreate a directory.

        Args:
            path (str): Directory path.
        """
        if os.path.exists(path):
            shutil.rmtree(path)
        os.makedirs(path, exist_ok=True)

    @staticmethod
    def list_all_files(path: str) -> List[str]:
        """
        List all files in a local directory recursively.

        Args:
            path (str): Directory path.

        Returns:
            List[str]: Sorted list of file paths.
        """
        return sorted(
            os.path.join(root, filename)
            for root, _, files in os.walk(path)
            for filename in files
        )

    def list_objects_v2(self, bucket: str, prefix: str = "", delimiter: str = "/") -> Dict:
        """
        List objects in an S3 bucket using pagination.

        Args:
            bucket (str): S3 bucket name.
            prefix (str): Prefix to filter objects.
            delimiter (str): Delimiter for grouping keys.

        Returns:
            Dict: Dictionary with object contents and common prefixes.
        """
        paginator = self.s3_client.get_paginator("list_objects_v2")
        objects, prefixes = [], []

        for resp in paginator.paginate(Bucket=bucket, Prefix=prefix, Delimiter=delimiter):
            objects.extend(resp.get("Contents", []))
            prefixes.extend(resp.get("CommonPrefixes", []))

        return {"Contents": objects, "CommonPrefixes": prefixes}

    def list_files_s3_parallel(self, bucket: str, prefix: str = "", delimiter: str = "/") -> List[Tuple[str, str]]:
        """
        List all files in an S3 bucket concurrently.

        Args:
            bucket (str): S3 bucket name.
            prefix (str): Prefix to filter objects.
            delimiter (str): Delimiter for grouping keys.

        Returns:
            List[Tuple[str, str]]: Sorted list of file keys and their last modified timestamps.
        """
        start_time = time.perf_counter()
        logging.info(f"Listing all files under: {bucket}/{prefix}.")

        objects = []
        tasks = {concurrent.futures.ThreadPoolExecutor().submit(self.list_objects_v2, bucket, prefix, delimiter)}

        while tasks:
            done, _ = concurrent.futures.wait(tasks, return_when=concurrent.futures.FIRST_COMPLETED)
            for future in done:
                result = future.result()
                objects.extend(result.get("Contents", []))
                for prefix_entry in result.get("CommonPrefixes", []):
                    tasks.add(
                        concurrent.futures.ThreadPoolExecutor().submit(
                            self.list_objects_v2, bucket, prefix_entry["Prefix"], delimiter
                        )
                    )
            tasks -= done

        s3_file_paths = [
            (obj["Key"], obj["LastModified"])
            for obj in objects if not obj["Key"].endswith("/")
        ]

        logging.info(f"Files found: {len(s3_file_paths)} in {time.perf_counter() - start_time:.4f} seconds.")
        return sorted(s3_file_paths)

    def download(self, s3_file_path: str, bucket: str, s3_base_path: str, local_download_path: str) -> None:
        """
        Download a file from S3 to a local directory.

        Args:
            s3_file_path (str): S3 file path.
            bucket (str): S3 bucket name.
            s3_base_path (str): S3 base path to remove from the file path.
            local_download_path (str): Local download directory.
        """
        relative_path = s3_file_path[len(s3_base_path):].lstrip("/")
        local_path = os.path.join(local_download_path, relative_path)
        os.makedirs(os.path.dirname(local_path), exist_ok=True)

        try:
            self.s3_client.download_file(bucket, s3_file_path, local_path)
        except ClientError as e:
            logging.error(f"Download error: {e} | S3 path: {s3_file_path}")

    def download_parallel(self, bucket: str, s3_base_path: str, local_download_path: str, file_ext_filter: Optional[str] = None) -> None:
        """
        Download multiple files from S3 concurrently.

        Args:
            bucket (str): S3 bucket name.
            s3_base_path (str): Base path in S3 to download from.
            local_download_path (str): Local directory to download files to.
            file_ext_filter (Optional[str]): File extension to filter by.
        """
        start_time = time.perf_counter()
        logging.info(f"Downloading files from: {bucket}/{s3_base_path}.")
        
        self.make_clean_dir(local_download_path)

        s3_file_paths = self.list_files_s3_parallel(bucket, s3_base_path)
        if file_ext_filter:
            file_ext_filter = file_ext_filter if file_ext_filter.startswith(".") else f".{file_ext_filter}"
            s3_file_paths = [fp for fp in s3_file_paths if fp[0].endswith(file_ext_filter)]

        with concurrent.futures.ThreadPoolExecutor() as executor:
            list(
                tqdm(
                    executor.map(
                        self.download,
                        [fp[0] for fp in s3_file_paths],
                        [bucket] * len(s3_file_paths),
                        [s3_base_path] * len(s3_file_paths),
                        [local_download_path] * len(s3_file_paths),
                    ),
                    total=len(s3_file_paths),
                    desc="Downloading files"
                )
            )

        logging.info(f"Downloaded {len(s3_file_paths)} files in {time.perf_counter() - start_time:.4f} seconds.")

    def upload(self, file_path: str, local_upload_path: str, bucket: str, s3_base_path: str) -> None:
        """
        Upload a file to S3.

        Args:
            file_path (str): Local file path.
            local_upload_path (str): Base local path to remove.
            bucket (str): S3 bucket name.
            s3_base_path (str): S3 base path to upload to.
        """
        relative_path = file_path[len(local_upload_path):].lstrip("/")
        s3_path = os.path.join(s3_base_path, relative_path)

        try:
            self.s3_client.upload_file(file_path, bucket, s3_path)
        except ClientError as e:
            logging.error(f"Upload error: {e} | File: {file_path}")

    def upload_parallel(self, local_upload_path: str, bucket: str, s3_base_path: str) -> None:
        """
        Upload multiple files to S3 concurrently.

        Args:
            local_upload_path (str): Local directory to upload files from.
            bucket (str): S3 bucket name.
            s3_base_path (str): S3 base path to upload to.
        """
        start_time = time.perf_counter()
        logging.info(f"Uploading files from: {local_upload_path}.")

        file_paths = self.list_all_files(local_upload_path)

        with concurrent.futures.ThreadPoolExecutor() as executor:
            list(
                tqdm(
                    executor.map(
                        self.upload,
                        file_paths,
                        [local_upload_path] * len(file_paths),
                        [bucket] * len(file_paths),
                        [s3_base_path] * len(file_paths),
                    ),
                    total=len(file_paths),
                    desc="Uploading files"
                )
            )

        logging.info(f"Uploaded {len(file_paths)} files in {time.perf_counter() - start_time:.4f} seconds.")

    def delete(self, bucket: str, s3_path: str) -> None:
        """
        Delete files from an S3 path.

        Args:
            bucket (str): S3 bucket name.
            s3_path (str): S3 path to delete.
        """
        try:
            self.s3_resource.Bucket(bucket).objects.filter(Prefix=s3_path).delete()
            logging.info(f"Deleted files under {bucket}/{s3_path}.")
        except ClientError as e:
            logging.error(f"Delete error: {e} | S3 path: {s3_path}")
