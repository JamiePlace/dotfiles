local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'pyright',
    'lua_ls',
    'rust_analyzer'
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  ["<S-Tab>"] = cmp.mapping.complete(),
})

cmp_mappings['<CR>'] = nil
lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

function Format()
    vim.cmd("silent !black --quiet %")
    vim.cmd("edit")
    vim.cmd("silent !isort --quiet %")
    vim.cmd("edit")
end

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "<leader>fm", function() Format() end, opts)
  vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.formatting() end, opts)
  vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>")

end)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local python_prog = vim.g.python3_host_prog
if python_prog == nil then
    python_prog = ""
end

require('lspconfig').pyright.setup {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "off",
                useLibraryCodeForTypes = true
            }
        }
    },
    capabilities = capabilities
}
require('lspconfig').lua_ls.setup({})

require('lspconfig').r_language_server.setup({
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
