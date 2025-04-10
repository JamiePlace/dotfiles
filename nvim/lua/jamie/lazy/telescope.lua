return {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzf-native.nvim',
        build = "make",
    },
    config = function()
        require('telescope').setup {
            defaults = {
                file_ignore_patterns = {
                    ".venv/*",
                    ".git/*",
                    "__pycache__/*"
                },
            },
            pickers = {
                find_files = {
                    hidden = true
                }
            },
            extensions = {
                fzf = {
                    fuzzy = true,                    -- false will only do exact matching
                    override_generic_sorter = true,  -- override the generic sorter
                    override_file_sorter = true,     -- override the file sorter
                    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            }
        }
        -- To get fzf loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        require('telescope').load_extension('fzf')
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', function() builtin.find_files({path_display = { "truncate" }}) end, {})
        vim.keymap.set('n', '<leader>pws', function() local word = vim.fn.expand("<cword>") builtin.grep_string({ search = word }) end)
        vim.keymap.set('n', '<leader>pWs', function() local word = vim.fn.expand("<cWORD>") builtin.grep_string({ search = word }) end)
        vim.keymap.set('n', '<leader>gg', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end) vim.keymap.set('n', '<leader>pg', function() builtin.live_grep({path_display = { "truncate" }}) end, {})
        vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>ffm', function()
            builtin.find_files({
                prompt_title = "Find Markdown Files",
                find_command = {'rg', '--files', '--type', 'md'}
            })
        end, { desc = 'Find Markdown files' })
    end
}

