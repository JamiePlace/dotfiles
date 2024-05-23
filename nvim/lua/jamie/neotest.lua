require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
  },
})

require("neodev").setup({
  library = { plugins = { "neotest" }, types = true },
  ...
})

vim.keymap.set("n", "<leader>tm", function() require("neotest").run.run() require("neotest").summary.open() end)
vim.keymap.set("n", "<leader>tp", function() require("neotest").run.run(vim.fn.expand("%")) require("neotest").summary.open() end)
vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({strategy="dap"}) end)
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.close() require("neotest").run.stop() end)

