require("jamie.lazy")
require("jamie.remap")
require("jamie.lspconfig")
require("jamie.telescope")
require("jamie.colours")
require("jamie.set")
require("jamie.neodev")
require("jamie.dap")
require("jamie.dapui")
require("jamie.cellularautomaton")


if vim.fn.has('macunix') == 0 then
    vim.cmd([[
		let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
		let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
		let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
		let &shellpipe  = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
		set shellquote= shellxquote=
    ]])
end
-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
