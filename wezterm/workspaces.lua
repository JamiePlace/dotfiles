local wezterm = require 'wezterm'
local mux = wezterm.mux
local proj_workspaces = require 'project_workspaces'

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

local
function home_computer()
    local directory = os.getenv("HOME")
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

wezterm.on('gui-startup', function(cmd)

    -- home
    default()
    -- projects
    projects()
    -- config
    config()

    if home_computer() then
        proj_workspaces.home()
    else
        proj_workspaces.work()
    end


    mux.set_active_workspace 'home'
end)
