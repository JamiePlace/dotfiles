vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.g.copilot_filetypes = {
	["*"] = false,
	["rust"] = true,
	["python"] = true,
    ["markdown"] = true,
    ["powershell"] = true
}
