return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "nvim-neotest/neotest",
        "nvim-neotest/neotest-python",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python",
        "nvim-neotest/nvim-nio",
        "LiadOz/nvim-dap-repl-highlights",
        "folke/neodev.nvim"
    },
    config = function()
        -- Setup dap-python with project root as cwd
        local path = require('plenary.path')
        require("dap-python").setup("python", {
            -- This will make dap-python start debugging from the project root
            cwd = function()
                -- Try to find the project root using common project markers
                local markers = {'pyproject.toml'}
                local cwd = vim.fn.getcwd()
                for _, marker in ipairs(markers) do
                    -- Search upward for project markers
                    local root = vim.fs.find(marker, {
                        upward = false,
                        path = cwd,
                        type = 'file'
                    })[1]
                    if root then
                        return vim.fs.dirname(root)
                    end
                end
                -- Fallback to current working directory
                return cwd
            end,
            -- You can also set pythonPath if needed
            -- pythonPath = function()
            --     -- Return path to python from active virtual environment
            --     return path.join(vim.fn.getcwd(), '.venv', 'bin', 'python')
            -- end,
        })
        require('nvim-dap-repl-highlights').setup()
        -- keybindings
        vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
        vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
        vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

        vim.fn.sign_define('DapBreakpoint', { text='B', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointCondition', { text='cB', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
        vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
        vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

        vim.keymap.set("n", "<leader>br", ':DapToggleBreakpoint<CR>', { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>cbr", ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint Condition > "))<CR>', { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>dd", ':DapContinue<CR>', { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>de", function()
            vim.cmd("vsp dap-eval://python")
            vim.cmd("vertical resize 40")  -- Adjust the width as desired
        end, { desc = "Open DAP Eval buffer on the right with width 50" })
        vim.keymap.set("n", "<leader>dt", ':DapTerminate<CR>', { noremap = true, silent = true })

        vim.keymap.set({'n', 'v'}, '<C-k>', ':lua require("dapui").eval()<CR>',{ noremap = true, silent = true })
        vim.keymap.set({'n', 'v'}, '<C-k>', function()
            require("dapui").eval(nil, { enter = true, context = "console" })
        end, { desc = "Evaluate expression under cursor in console" })

        require("dapui").setup({
            layouts = {
                {
                    elements = {
                        -- Exclude "repl" to prevent the REPL window from opening
                        "scopes",
                        "breakpoints",
                        "stacks",
                    },
                    size = 40, -- Adjust the size as needed
                    position = "left", -- Can be "left", "right", "top", or "bottom"
                },
                {
                    elements = {
                        "console",
                    },
                    size = 10,
                    position = "bottom",
                }
            },
        })

        vim.api.nvim_create_autocmd("BufWinEnter", {
            pattern = "dap-repl*",
            callback = function()
                vim.schedule(function()
                    vim.cmd("close")  -- Hide it automatically
                end)
            end,
        })

        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        require("neodev").setup({
            library = { plugins = { "nvim-dap-ui" }, types = true },
        })
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                }),
            },
        })

        require("neodev").setup({
            library = { plugins = { "neotest" }, types = true },
        })

        vim.keymap.set("n", "<leader>tm", function() require("neotest").run.run() require("neotest").summary.open() end)
        vim.keymap.set("n", "<leader>tp", function() require("neotest").run.run(vim.fn.expand("%")) require("neotest").summary.open() end)
        vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({strategy="dap"}) end)
        vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.close() require("neotest").run.stop() end)
    end
}
