local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    -- theme
    {'Mofiqul/vscode.nvim', lazy = false, priority = 1000},
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    -- bar at the bottom
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    -- git
    {"tpope/vim-fugitive"},
    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "markdown", "markdown_inline", "r", "rnoweb","lua", "vim", "python", "rust", "bash", "json", "toml", "vimdoc"},
                ignore_install = {"yaml"},
                sync_install = false,
                highlight = { enable = true , additional_vim_regex_highlighting = false},
                indent = { enable = true },
            })
        end
    },
    {"ikatyang/tree-sitter-yaml"},
    -- R
    {
        "R-nvim/R.nvim",
        lazy = false,
        opts = {
            -- Create a table with the options to be passed to setup()
            R_args = { "--quiet", "--no-save" },
            hook = {
                on_filetype = function()
                    -- This function will be called at the FileType event
                    -- of files supported by R.nvim. This is an
                    -- opportunity to create mappings local to buffers.
                    vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
                    vim.keymap.set("v", "<Enter>", "<Plug>RSendSelection", { buffer = true })
                end,
            },
            pdfviewer = "",
            assign_map = "<NOP>",
        },
    },
    {
        "R-nvim/cmp-r",
        {
            "hrsh7th/nvim-cmp",
            config = function()
                local cmp = require("cmp")
                cmp.setup({
                    sources = {{ name = "cmp_r" }},
                })
                require("cmp_r").setup({ })
            end,
        },
    },
    -- lsp
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    },
    { "williamboman/mason.nvim" },
    -- fugitive "git"
    {"tpope/vim-fugitive"},
    -- telescope "fuzzy finder"
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- fzf telescope
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    -- autopairs
    {
        "windwp/nvim-autopairs", event="InsertEnter", opts = {},
        config = function()
            require('nvim-autopairs').setup({ })
        end
    },
    -- copilot
    {
        "github/copilot.vim",
        lazy = false,
        config = function()
            vim.g.copilot_assume_mapped = true
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Accept("<CR>")', {expr=true, silent=true})
            vim.g.copilot_filetypes = {
                ["*"] = true,
                ["rust"] = true,
                ["python"] = true,
                ["lua"] = true,
            }
        end
    },
    -- zenmode
    {
        "folke/zen-mode.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {"eandrju/cellular-automaton.nvim"},
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    -- dap
    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", "nvim-neotest/nvim-nio", "LiadOz/nvim-dap-repl-highlights"} },
    { "folke/neodev.nvim", opts = {} },
    -- scrolling past end of file
    {
        'Aasim-A/scrollEOF.nvim',
        event = { 'CursorMoved', 'WinScrolled' },
        opts = {},
    },
    -- surround
    {"tpope/vim-surround"},
    -- docstrings
    {
        'kkoomen/vim-doge',
        build = ':call doge#install()'

    },
    -- todo comments
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    },
    -- better escape
    {"max397574/better-escape.nvim"},
    -- oil
    {"stevearc/oil.nvim"},
    -- neotest
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-neotest/neotest-python",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        }
    },
    -- markdown preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    }
})


