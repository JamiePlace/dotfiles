#!/bin/bash
apt update
apt upgrade -y
snap install docker.io
apt install amazon-ecr-credential-helper -y

sudo mkdir -p /home/ubuntu/.docker
echo '{ "credsStore": "ecr-login" }' | sudo tee /home/ubuntu/.docker/config.json > /dev/null

sudo chown -R ubuntu:ubuntu /home/ubuntu/.docker

apt install build-essential -y
curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb
apt install -y ./wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb
rm wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb

curl -sSf https://rye.astral.sh/get | RYE_INSTALL_OPTION="--yes" bash
echo 'source "$HOME/.rye/env"' >> ~/.bashrc
