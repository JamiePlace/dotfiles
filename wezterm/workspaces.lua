local wezterm = require 'wezterm'
local mux = wezterm.mux
local proj_workspaces = require 'project_workspaces'
local tools = require 'tools'

local
function default()
    local home = os.getenv("HOME")
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'home',
        cwd = home,
    }
end

wezterm.on('gui-startup', function(cmd)

    -- home
    default()
    mux.set_active_workspace 'home'
end)
