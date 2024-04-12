local telescope = require('telescope')

telescope.setup {
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
    }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')
