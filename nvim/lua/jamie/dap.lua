require("dap-python").setup("python")
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


vim.keymap.set('n', '<C-s>', ':lua require("dapui").eval()<CR>',{ noremap = true, silent = true })
vim.keymap.set('v', '<C-s>', ':lua require("dapui").eval()<CR>',{ noremap = true, silent = true })
