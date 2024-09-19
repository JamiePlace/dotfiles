local wezterm = require("wezterm")
local act = wezterm.action
local python_version = "3.10"
local home_computer

local M = {}

M.python_version = python_version

M.on_unix = function()
    if (package.config:sub(1,1)) == ("\\") then
        return false
    end
    return true

end

-- Check if the computer is a home computer
---@rtype boolean
M.home_computer = function()
    local directory
    if M.on_unix() then
        directory = os.getenv("HOME")
    else
        directory = "C:\\Users\\jamie"
    end

    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        if filename == "myprojects" then
            return true
        end
    end
    pfile:close()
    return false
end

-- Get a random background from the backgrounds directory
---@rtype string
M.random_background = function()
    local directory = "/Users/jamieplace/Pictures/backgrounds/"
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    local rand = math.random(1, #t)
    return directory .. t[rand-1]
end


M.theme_switcher = function(window, pane)
    -- get builting color schemes
    local schemes = wezterm.get_builtin_color_schemes()
    local choices = {}
    if M.home_computer() then
        local config_path = "/C/Users/jamie/.config/wezterm/wezterm.lua"
    else
        local config_path = "/Users/jamieplace/.config/wezterm/wezterm.lua"
    end

    -- populate theme names in choices list
    for key, _ in pairs(schemes) do
        table.insert(choices, { label = tostring(key) })
    end

    -- sort choices list
    table.sort(choices, function(c1, c2)
        return c1.label < c2.label
    end)

    window:perform_action(
        act.InputSelector({
            title = "🎨 Pick a Theme!",
            choices = choices,
            fuzzy = true,

            -- execute 'sed' shell command to replace the line 
            -- responsible of colorscheme in my config
            action = wezterm.action_callback(function(inner_window, inner_pane, _, label)
                inner_window:perform_action(
                    act.SpawnCommandInNewTab({
                        args = {
                            "sed",
                            "-i",
                            '/^config.color_scheme/c\\config.color_scheme = "' .. label .. '"',
                            config_path,
                        },
                    }),
                    inner_pane
                )
            end),
        }),
        pane
    )
end


return M
