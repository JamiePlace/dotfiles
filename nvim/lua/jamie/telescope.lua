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
function OnUnix()
    if (package.config:sub(1,1)) == ("\\") then
        return false
    end
    return true

end
if OnUnix() then
	-- To get fzf loaded and working with telescope, you need to call
	-- load_extension, somewhere after setup function:
	telescope.load_extension('fzf')
end
