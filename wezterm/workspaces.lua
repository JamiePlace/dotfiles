local wezterm = require 'wezterm'
local mux = wezterm.mux

local function home()
    if not os.getenv("HOME") then
        return "\\\\wsl.localhost\\Ubuntu\\home\\jamie"
    else
        return os.getenv("HOME")
    end
end

local
function default()
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'home',
        cwd = home(),
    }
end

local function config()
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'config',
        cwd = wezterm.home_dir .. "/.config",
    }
end

wezterm.on('gui-startup', function(cmd)
    -- home
    default()
    -- config
    config()
    mux.set_active_workspace 'home'
end)
