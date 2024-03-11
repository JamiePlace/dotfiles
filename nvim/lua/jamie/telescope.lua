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
