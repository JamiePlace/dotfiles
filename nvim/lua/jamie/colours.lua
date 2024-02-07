require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
    term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
})
--require('github-theme').setup({disable_background = true})
function ColorMyPencils(color)
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
	vim.api.nvim_set_hl(0, "DiagnosticError", { bg = "none" })
	vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none" })
	vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = "none" })
	vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = "none" })
	vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "none" })

end

ColorMyPencils()
