return {
    "github/copilot.vim",
    lazy = false,
    config = function()
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_no_tab_map = true
        vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Accept("<CR>")', {expr=true, silent=true})
        vim.g.copilot_filetypes = {
            ["*"] = false,
            ["yaml"] = true,
            ["yml"] = true,
            ["markdown"] = true,
            ["json"] = true,
            ["html"] = true,
            ["css"] = true,
            ["rust"] = true,
            ["python"] = true,
            ["lua"] = true,
        }
    end
}
