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
        require("dap-python").setup("python")
        require('nvim-dap-repl-highlights').setup()
        -- read .vscode/launch.json
        require('dap.ext.vscode').load_launchjs()
        require("dap").configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch File: no args",
                console = "integratedTerminal",
                program = "${file}",
                cwd = "${workspaceFolder}",
            }
        }
        -- keybindings
        vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
        vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
        vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

        vim.fn.sign_define('DapBreakpoint', { text='B', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointCondition', { text='C', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
        vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
        vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

        vim.keymap.set("n", "<leader>br", ':DapToggleBreakpoint<CR>', { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>ebr", ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint Condition > "))<CR>', { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>db", ':DapLoadLaunchJSON<CR> :DapContinue<CR>', { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>dd", ':DapContinue<CR>', { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>de", ':DapTerminate<CR>', { noremap = true, silent = true })


        vim.keymap.set('n', '<C-k>', ':lua require("dapui").eval()<CR>',{ noremap = true, silent = true })

        require("dapui").setup()

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
