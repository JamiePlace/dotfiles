vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<C-a>", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- if __name__ == "__main__": block
vim.keymap.set("n", "<leader>m", function()
  vim.api.nvim_put({ 'if __name__ == "__main__":' }, 'l', true, true)
end, { desc = "Insert Python main check" })

-- run python file in split to the bottom
vim.keymap.set("n", "<leader>rr", function()
  vim.cmd("40 split")
  vim.cmd("wincmd j")
  vim.cmd("terminal python %")
end, { desc = "Run Python file in split" })

-- run rye sync to update dependencies
vim.keymap.set("n", "<leader>rs", function()
    vim.cmd("40 vsplit")
    vim.cmd("wincmd l")
    vim.cmd("terminal rye sync")
end, { desc = "rye sync" })

-- proportional symbol
vim.keymap.set("i", "<C-a>", "∝", { desc = "proportional" })
vim.keymap.set("i", "<C-d>", function()
    local current_date = os.date("%Y-%m-%d")
    vim.api.nvim_put({current_date}, 'c', true, true)
end, { desc = "current date" })

vim.keymap.set("i", "<C-P>", '<C-R> "', { desc = "Paste from last yank" })

vim.keymap.set("n", ",", ";")
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<C-s>","<CMD>w<CR>")

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
vim.keymap.set("i", "<C-p>", [[<C-o>"+p]])
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

-- split buffer
vim.keymap.set("n", "<C-'>", ":vsp<CR>", { silent = true })
vim.keymap.set("n", "<C-;>", ":sp<CR>", { silent = true })
-- resize with arrows
vim.keymap.set({"n", "t", "v"}, "<M-J>", "2<C-w>-", { silent = true })
vim.keymap.set({"n", "t", "v"}, "<M-K>", "2<C-w>+", { silent = true })
vim.keymap.set({"n", "t", "v"}, "<M-H>", "2<C-w><", { silent = true })
vim.keymap.set({"n", "t", "v"}, "<M-L>", "2<C-w>>", { silent = true })
-- jump to previous buffer
vim.keymap.set("n", "<leader>ll", ":b#<CR>", { silent = true })

--vim.keymap.set('n', '<leader>pr',function() builtin.lsp_references({show_line=false, path_display = { "truncate" }}) end, { noremap = true, silent = true})
-- open terminal
vim.keymap.set("n", "<leader>rt", ":vsplit<CR><C-w>l:te<CR>")
vim.keymap.set("n", "<leader>bt", ":vsplit<CR><C-w>l:te<CR>")


-- my repl solution
-- could do this better where I look for the ptpython buffer and then
-- move text from the current buffer to the ptpython buffer
local function term_nav(key)
  return function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N><C-w>" .. key, true, false, true), "n", false)
  end
end

local function term_prev_buf()
    return function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>:b#<CR>", true, false, true), "n", false)
    end
end
vim.keymap.set("n", "<leader>rp", ":vsplit<CR><C-w>l:terminal ptipython<CR>")
vim.keymap.set('n', "<leader>]", "yy<C-w>lpa<CR><CR>")
vim.keymap.set('v', "<leader>]", "y<C-w>lpa<CR><CR>")
vim.keymap.set('n', "<C-Q>", "yy<C-w>lpa<CR><CR>")
vim.keymap.set('v', "<C-Q>", "y<C-w>lpa<CR><CR>")
vim.keymap.set('t', "<C-B>", term_prev_buf(), { noremap = true, silent = true })
-- lsp restart
vim.keymap.set('n', "<leader>lr", ":LspRestart<CR>")
-- R
-- assignment
vim.keymap.set("i", "<C-[>", "<-", { desc = "Assignment Operator" })
-- pipe operator
vim.keymap.set("i", "<C-]>", "|>", { desc = "Pipe Operator" })
-- function docstring
vim.keymap.set("i", "<C-\\>", "#' ", { desc = "Pipe Operator" })
-- 
--
--
-- obsidian new note from template
vim.keymap.set("n", "<leader>nf", "<CMD>ObsidianTemplate<CR>", { desc = "Insert Template" })
