return {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",

        -- see below for full list of optional dependencies 👇
    },
    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/notes/personal",
            },
            {
                name = "work",
                path = "~/notes/work",
            },
        },
        ui = { enable = false },
        follow_url_func = function(url)
            -- Open the URL in the default web browser.
            vim.fn.jobstart({"open", url})  -- Mac OS
            -- vim.fn.jobstart({"xdg-open", url})  -- linux
            -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
            -- vim.ui.open(url) -- need Neovim 0.10.0+
        end,
        follow_img_func = function(img)
            vim.fn.jobstart { "qlmanage", "-p", img }  -- Mac OS quick look preview
            -- vim.fn.jobstart({"xdg-open", url})  -- linux
            -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
        end,
        picker = {
            -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
            name = "telescope.nvim",
            -- Optional, configure key mappings for the picker. These are the defaults.
            -- Not all pickers support all mappings.
            note_mappings = {
                -- Create a new note from your query.
                new = "<C-x>",
                -- Insert a link to the selected note.
                insert_link = "<C-l>",
            },
            tag_mappings = {
                -- Add tag(s) to current note.
                tag_note = "<C-x>",
                -- Insert a tag at the current location.
                insert_tag = "<C-l>",
            },
        },
        -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
        completion = {
            -- Set to false to disable completion.
            nvim_cmp = true,
            -- Trigger completion at 2 chars.
            min_chars = 0,
        },
        templates = {
            folder = "999Templates",
            date_format = "%Y-%m-%d-%a",
            time_format = "%H:%M",
        },

        -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
        -- way then set 'mappings = {}'.
        mappings = {
            -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
            ["gf"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true },
            },
            -- Toggle check-boxes.
            ["<leader>ch"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true },
            },
            -- Smart action depending on context, either follow link or toggle checkbox.
            ["<cr>"] = {
                action = function()
                    return require("obsidian").util.smart_action()
                end,
                opts = { buffer = true, expr = true },
            }
        },
    },
}
