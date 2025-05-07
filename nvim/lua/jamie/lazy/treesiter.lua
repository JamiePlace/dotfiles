return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "markdown",
                "markdown_inline",
                "r",
                "rnoweb","lua",
                "vim",
                "python",
                "rust",
                "bash",
                "json",
                "toml",
                "vimdoc",
                "yaml",
                "sql",
                "terraform"
            },
            sync_install = false,
            highlight = { enable = true},
            indent = { enable = true },
        })
    end
}
