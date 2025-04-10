require("jamie.set")
require("jamie.remap")
require("jamie.fetch_aws_login")
require("jamie.lazy_init")

local augroup = vim.api.nvim_create_augroup
local JamieGroup = augroup('Jamie', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

autocmd('LspAttach', {
    group = JamieGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>fm", ":Format", opts)
        -- set bedrock keys
        vim.keymap.set("n", "<leader>sk", function() SetBedrockKeys(vim.fn.input("Profile> ")) end, opts)
    end
})

autocmd('BufWinEnter', {
    pattern = { '*.md' },
    callback = function()
        vim.opt.colorcolumn = ''
        vim.opt.wrap = true
        vim.opt.breakindent = true
        vim.opt.showbreak = ""
        vim.opt.linebreak = true
    end,
})
autocmd({ 'BufWinLeave' }, {
    pattern = { '*.md' },
    callback = function()
        vim.opt.colorcolumn = '90'
        vim.opt.textwidth = 90
        vim.opt.wrap = false
        vim.opt.linebreak = false
    end,
})

-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
