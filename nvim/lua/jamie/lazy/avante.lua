return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
        provider = "Agent-Fineman",
        auto_suggestions_provider = "Agent-Bohr",
        vendors = {
            ["Agent-Fineman"] = {
                __inherited_from = "bedrock",
                api_key_name = "BEDROCK_KEYS",
                model = "us.anthropic.claude-3-7-sonnet-20250219-v1:0",
             },
            ["Agent-Bohr"] = {
                __inherited_from = "bedrock",
                api_key_name = "BEDROCK_KEYS",
                model = "us.anthropic.claude-3-5-haiku-20241022-v1:0",
             }
        },
        behaviour = {
            auto_focus_sidebar = true,
            auto_suggestions = false, -- Experimental stage
            auto_suggestions_respect_ignore = false,
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            jump_result_buffer_on_finish = false,
            support_paste_from_clipboard = false,
            minimize_diff = true,
            enable_token_counting = true,
            enable_cursor_planning_mode = true,
            enable_claude_text_editor_tool_mode = false,
            use_cwd_as_project_root = true,
        },
        mappings = {
            ---@class AvanteConflictMappings
            diff = {
                ours = "co",
                theirs = "ct",
                all_theirs = "ca",
                both = "cb",
                cursor = "cc",
                next = "]x",
                prev = "[x",
            },
            suggestion = {
                accept = "<C-J>",
                next = "<C-]>",
                prev = "<C-[>",
                dismiss = "<M-]>",
            },
            jump = {
                next = "]]",
                prev = "[[",
            },
            submit = {
                normal = "<CR>",
                insert = "<C-s>",
            },
            cancel = {
                normal = { "<C-c>", "<Esc>", "q" },
                insert = { "<C-c>" },
            },
            -- NOTE: The following will be safely set by avante.nvim
            ask = "<leader>aa",
            edit = "<leader>ae",
            refresh = "<leader>ar",
            focus = "<leader>af",
            stop = "<leader>ast",
            toggle = {
                default = "<leader>at",
                debug = "<leader>ad",
                hint = "<leader>ah",
                suggestion = "<leader>asg",
                repomap = "<leader>aR",
            },
            sidebar = {
                apply_all = "A",
                apply_cursor = "a",
                retry_user_request = "r",
                edit_user_request = "e",
                switch_windows = "<Tab>",
                reverse_switch_windows = "<S-Tab>",
                remove_file = "d",
                add_file = "@",
                close = { "<Esc>", "q" },
                close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
            },
            files = {
                add_current = "<leader>ab", -- Add current buffer to selected files
                add_all_buffers = "<leader>az", -- Add all buffer files to selected files
            },
            select_model = "<leader>a?", -- Select model command
            select_history = "<leader>ah", -- Select history command
        },
        hints = {
            enabled = false
        },
        windows = {
            position = "left",
            input = {
                prefix = "> ",
                height = 12, -- Height of the input window in vertical layout
            },
            edit = {
                border = { " ", " ", " ", " ", " ", " ", " ", " " },
                start_insert = true, -- Start insert mode when opening the edit window
            },
            ask = {
                floating = true, -- Open the 'AvanteAsk' prompt in a floating window
                border = "single",
                start_insert = false, -- Start insert mode when opening the ask window
                focus_on_apply = "ours", -- which diff to focus after applying
            },
        },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
