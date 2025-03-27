return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    config = function()
        -- trouble
        vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
        vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
        vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
        vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
        vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
        vim.keymap.set("n", "<leader>pr", function() require("trouble").toggle("lsp_references") end)
        -- TODO comments
        vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
        vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
        vim.keymap.set("n", "<leader>tt", function() vim.cmd(":TodoTrouble") end, { desc = "All todos in project" })
    end
}
