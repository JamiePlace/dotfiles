require("jamie.lazy")
require("jamie.remap")
require("jamie.lspconfig")
require("jamie.colours")
require("jamie.set")

if not vim.fn.has('macunix') then
    vim.g.terminal_emulator='powershell'
end
-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
