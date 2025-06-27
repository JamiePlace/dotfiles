return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip"
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
                python = { "ruff_check", "ruff_format"},
                terraform = { "terraform_fmt" },
            },
            formatters = {
                ruff_check = {
                    command = "ruff",
                    args = { "check", "--fix", "$FILENAME" },
                    to_temp_file = true,
                    stdin = true,
                },
                ruff_format = {
                    command = "ruff",
                    args = { "format", "$FILENAME" },
                    to_temp_file = true,
                    stdin = true,
                },
                terraform_fmt = {
                    command = "terraform",
                    args = { "fmt", "$FILENAME" },
                    to_temp_file = true,
                    stdin = true,
                },
            },
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        local util = require('lspconfig.util')

        -- Function to find and activate the virtual environment
        local function get_python_path(workspace, bin)
            bin = bin or false
            -- Use activated virtualenv
            if vim.env.VIRTUAL_ENV then
                if bin then
                    return util.path.join(vim.env.VIRTUAL_ENV, 'bin')
                else
                    return util.path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
                end
            end

            -- Find and use virtualenv in workspace directory
            for _, pattern in ipairs({'venv', '.venv'}) do
                local match = vim.fn.glob(util.path.join(workspace, pattern))
                if match ~= '' then
                    if bin then
                        return util.path.join(match, 'bin')
                    else
                        return util.path.join(match, 'bin', 'python')
                    end
                end
            end

            -- Fallback to system Python
            return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
        end
        local root_files = {
            "pyproject.toml", "setup.py", "setup.cfg",
            "requirements.txt", "Pipfile", ".git"
        }

        local find_root = function(fname)
            return util.root_pattern(unpack(root_files))(fname)
                or util.find_git_ancestor(fname)
                or util.path.dirname(fname)
        end

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "pyright",
                "ruff",
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "terraformls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup {
                        on_init = function(client)
                            local path = get_python_path(client.config.root_dir, false)
                            client.config.settings.python.pythonPath = path
                        end,
                        cmd = { get_python_path(vim.fn.getcwd(), true) .. "/pyright-langserver", "--stdio" },
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    ignore = { "*"},
                                    autoSearchPaths = true,
                                    diagnosticMode = "openFilesOnly",
                                    useLibraryCodeForTypes = true,
                                    typeCheckingMode = "off"
                                }
                            },
                        }
                    }
                end,
                ["ruff"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ruff.setup {
                    }
                end,
                ["rust_analyzer"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.rust_analyzer.setup {
                        capabilities = capabilities
                    }
                end,
                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup {
                        capabilities = capabilities
                    }
                end,
                ["terraformls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.terraformls.setup {
                        capabilities = capabilities,
                        cmd = { "terraform-ls", "serve" },
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                ["<S-Tab>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                    { name = 'buffer' },
                })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
