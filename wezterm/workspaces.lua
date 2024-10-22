local wezterm = require 'wezterm'
local mux = wezterm.mux
local proj_workspaces = require 'project_workspaces'
local tools = require 'tools'

if not tools.on_unix() then
    wezterm.home_dir = '/home/jamie/'
end

local
function default()
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'home',
        cwd = wezterm.home_dir,
    }
end


local
function projects()
    local project_dir = wezterm.home_dir .. "/projects/"
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'projects',
        cwd = project_dir,
    }
end

local
function config()
    local project_dir = wezterm.home_dir .. "/.config/"
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'config',
        cwd = project_dir,
    }
    if tools.on_unix() then
        build_pane:send_text 'git pull\n'
    else
        build_pane:send_paste 'git pull\r'
    end
end


wezterm.on('gui-startup', function(cmd)

    -- home
    default()
    -- projects
    projects()
    -- config
    config()

    proj_workspaces.work()

    mux.set_active_workspace 'home'
end)
