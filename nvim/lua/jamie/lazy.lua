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
    { "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 , config = true},
    -- bar at the bottom
	{
		'itchyny/lightline.vim',
		lazy = false, -- also load at start since it's UI
		config = function()
			-- no need to also show mode in cmd line when we have bar
			vim.o.showmode = false
			vim.g.lightline = {
				active = {
					left = {
						{ 'mode', 'paste' },
						{ 'readonly', 'filename', 'modified' }
					},
					right = {
						{ 'lineinfo' },
						{ 'percent' },
						{ 'fileencoding', 'filetype' }
					},
				},
				component_function = {
					filename = 'LightlineFilename'
				},
			}
            function LightlineFilenameInLua(opts)
                            if vim.fn.expand('%:t') == '' then
                                return '[No Name]'
                            else
                                return vim.fn.getreg('%')
                            end
                        end
                        -- https://github.com/itchyny/lightline.vim/issues/657
                        vim.api.nvim_exec(
                            [[
                            function! g:LightlineFilename()
                                return v:lua.LightlineFilenameInLua()
                            endfunction
                            ]],
                            true
                        )
		end
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
                ensure_installed = {  "lua", "vim", "python", "rust" },
                sync_install = false,
                highlight = { enable = true , additional_vim_regex_highlighting = false},
                indent = { enable = true },
            })
        end
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
    --{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
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
                ["*"] = false,
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
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            'mfussenegger/nvim-dap-python',
            "LiadOz/nvim-dap-repl-highlights"
        },
        build = ":TSInstall dap-repl"
    },
    { "folke/neodev.nvim", opts = {} },
    -- scrolling past end of file
    {
        'Aasim-A/scrollEOF.nvim',
        event = { 'CursorMoved', 'WinScrolled' },
        opts = {},
    },
    -- surround
    {"tpope/vim-surround"},
    -- obsidian
    {
        "epwalsh/obsidian.nvim",
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        --   "BufReadPre path/to/my-vault/**.md",
        --   "BufNewFile path/to/my-vault/**.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
    },
    -- twilight
    {
        "folke/twilight.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    -- docstrings
    {
        'kkoomen/vim-doge',
        build = ':call doge#install()'

    },
})


