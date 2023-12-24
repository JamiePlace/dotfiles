vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--paste and copy from clipboard
vim.keymap.set("n", "<leader>pl", '"*p')
vim.keymap.set("n", "<leader>yl", '"*y')
vim.keymap.set("v", "<leader>pl", '"*p')
vim.keymap.set("v", "<leader>yl", '"*y')
-- vim.keymap.set('n', '<leader>sv', vim.cmd('source $MYVIMRC'))
-- Code Runner
vim.keymap.set("i", "<C-c>", "<Esc>")

-- jump to previous buffer
vim.keymap.set("n", "<leader>ll", "<C-6>")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { noremap = true, silent = true})

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.g.copilot_filetypes = {
	["*"] = false,
	["rust"] = true,
	["python"] = true,
}
