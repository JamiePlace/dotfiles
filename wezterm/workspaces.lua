local wezterm = require 'wezterm'
local mux = wezterm.mux
local proj_workspaces = require 'project_workspaces'
local tools = require 'tools'

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
    -- may as well kick off a build in that pane
    build_pane:send_text 'git pull\n'
end


wezterm.on('gui-startup', function(cmd)

    -- home
    default()
    -- projects
    projects()
    -- config
    config()

    if tools.home_computer() then
        proj_workspaces.home()
    else
        if tools.on_unix() then
            proj_workspaces.work()
        else
            proj_workspaces.home_windows()
        end
    end


    mux.set_active_workspace 'home'
end)
