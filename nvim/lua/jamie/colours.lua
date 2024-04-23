vim.o.background = "light"
--require("vscode").setup({})
function ColorMyPencils()
    --vim.cmd([[colorscheme gruvbox]])
    vim.cmd([[colorscheme catppuccin]])
--    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "DiagnosticError", { bg = "none" })
    vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none" })
    vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = "none" })
    vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = "none" })
    vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "none" })
end

ColorMyPencils()
