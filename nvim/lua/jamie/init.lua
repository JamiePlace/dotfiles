require("jamie.set")
require("jamie.remap")
require("jamie.fetch_aws_login")
require("jamie.lazy_init")

local augroup = vim.api.nvim_create_augroup
local JamieGroup = augroup('Jamie', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

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
        vim.keymap.set("n", "<leader>fm", function()
            require("conform").format({ async = false, lsp_format = "fallback"})
            vim.cmd("e!")
            vim.notify("Formatted file")
        end, opts)
        -- set bedrock keys
        vim.keymap.set("n", "<leader>sk", function() SetBedrockKeys(vim.fn.input("Profile> ")) end, opts)
    end
})


-- this handles markdown looking nice on enter and leaving
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

-- delete terminal buffers when they are closed
vim.api.nvim_create_autocmd("TermClose", {
  callback = function(args)
    local buf = args.buf
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "term" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end,
})
-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
