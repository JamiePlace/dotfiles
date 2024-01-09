vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("t", "<leader>pv", "<C-\\><C-n> :b# | Ex <CR>", {silent = true})
-- return to previous buffer
vim.keymap.set("t", "<C-a>", "<C-\\><C-n> :b# <CR>", { silent = true })
vim.keymap.set("n", "<C-a>", ":b# <CR>", { silent = true })

--paste and copy from clipboard
vim.keymap.set("n", "<leader>pl", '"*p')
vim.keymap.set("n", "<leader>yl", '"*y')
vim.keymap.set("v", "<leader>pl", '"*p')
vim.keymap.set("v", "<leader>yl", '"*y')
-- Move selected line / block of text in visual mode
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })
-- Move current line / block with Alt-j/k ala vscode.
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv-gv", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv-gv", { noremap = true, silent = true })
-- better indenting
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
-- move in and out of terminal 
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", { silent = true })
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>", { silent = true })
vim.keymap.set({"i", "v", "n"}, "<C-c>", "<Esc>")
-- resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })
-- jump to previous buffer
vim.keymap.set("n", "<leader>ll", "<C-6>")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function() builtin.find_files({path_display = { "truncate" }}) end, {})
vim.keymap.set('n', '<leader>pg', function() builtin.live_grep({path_display = { "truncate" }}) end, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
vim.keymap.set('n', '<leader>pr',function() builtin.lsp_references({show_line=false, path_display = { "truncate" }}) end, { noremap = true, silent = true})
-- trouble
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
-- open terminal
vim.keymap.set("n", "<leader>rt", ":vsplit<CR><C-w>l:te<CR>")
vim.keymap.set("n", "<leader>bt", ":vsplit<CR><C-w>l:te<CR>")

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.g.copilot_filetypes = {
	["*"] = false,
	["rust"] = true,
	["python"] = true,
}
