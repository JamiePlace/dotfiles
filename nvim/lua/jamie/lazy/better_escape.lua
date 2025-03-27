return {
      "max397574/better-escape.nvim",
      config = function()
        require("better_escape").setup {
            timeout = vim.o.timeoutlen,
            default_mappings = false,
            mappings = {
                i = {
                    j = {
                        -- These can all also be functions
                        j = "<Esc>",
                    },
                    k = {
                        -- These can all also be functions
                        k = "<Esc>",
                    },
                },
                n = {
                    j = {
                        j = false
                    },
                    k = {
                        k = false
                    }
                },
                v = {
                    j = {
                        k = false,
                    }
                },
                t = {
                    j = {
                        j = "<C-\\><C-n>",
                    },
                },
            },
        }

      end,
}
