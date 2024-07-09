vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", ",", ";")
vim.keymap.set("n", ";", ":")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
--paste and copy from clipboard
-- greatest remap ever
vim.keymap.set("x", "<leader>pl", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>P", [["+p]])
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
-- Move selected line / block of text in visual mode
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })
-- better indenting
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
-- move in and out of terminal 
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", { silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })
vim.keymap.set("i", "<Esc>", "<Esc>")
vim.keymap.set("i", "<C-c>", "<Esc>")
-- resize with arrows
vim.keymap.set("n", "<C-up>", ":resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-down>", ":resize +2<CR>", { silent = true })
vim.keymap.set("n", "<C-left>", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-right>", ":vertical resize +2<CR>", { silent = true })
-- jump to previous buffer
vim.keymap.set("n", "<leader>ll", ":b#<CR>", { silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function() builtin.find_files({path_display = { "truncate" }}) end, {})
vim.keymap.set('n', '<leader>pg', function() builtin.live_grep({path_display = { "truncate" }}) end, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
--vim.keymap.set('n', '<leader>pr',function() builtin.lsp_references({show_line=false, path_display = { "truncate" }}) end, { noremap = true, silent = true})
-- trouble
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "<leader>pr", function() require("trouble").toggle("lsp_references") end)
-- open terminal
vim.keymap.set("n", "<leader>rt", ":vsplit<CR><C-w>l:te<CR>")
vim.keymap.set("n", "<leader>bt", ":vsplit<CR><C-w>l:te<CR>")

-- my repl solution
-- could do this better where I look for the ptpython buffer and then
-- move text from the current buffer to the ptpython buffer
vim.keymap.set("n", "<leader>rp", ":vsplit<CR><C-w>l:terminal ptipython<CR>")
vim.keymap.set('n', "<leader>]", "yy<C-w>lpa<CR><CR>")
vim.keymap.set('v', "<leader>]", "y<C-w>lpa<CR><CR>")
-- lsp restart
vim.keymap.set('n', "<leader>lr", ":LspRestart<CR>")
-- docstrings
-- Generate comment for current line
vim.keymap.set('n', '<Leader>ds', '<Plug>(doge-generate)')
-- TODO comments
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
vim.keymap.set("n", "<leader>tt", function() vim.cmd(":TodoTrouble") end, { desc = "All todos in project" })

-- R
-- assignment
vim.keymap.set("i", "<C-[>", "<-", { desc = "Assignment Operator" })
-- pipe operator
vim.keymap.set("i", "<C-]>", "|>", { desc = "Pipe Operator" })
-- function docstring
vim.keymap.set("i", "<C-\\>", "#' ", { desc = "Pipe Operator" })
