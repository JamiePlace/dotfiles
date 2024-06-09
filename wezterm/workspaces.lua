local wezterm = require 'wezterm'
local mux = wezterm.mux

function default()
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'home',
        cwd = wezterm.home_dir,
    }
end


function projects()
    local project_dir = wezterm.home_dir .. "/projects/"
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'projects',
        cwd = project_dir,
    }
end

function config()
    local project_dir = wezterm.home_dir .. "/.config/"
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'config',
        cwd = project_dir,
    }
    -- may as well kick off a build in that pane
    build_pane:send_text 'git pull\n'
end

function project_workspace(name, dir)
    local project_dir = wezterm.home_dir .. "/projects/" .. dir
    local tab, build_pane, window = mux.spawn_window {
        workspace = name,
        cwd = project_dir,
    }
    local editor_pane = build_pane:split {
        direction = 'Top',
        size = 0.9,
        cwd = project_dir,
    }
    local git_pane = editor_pane:split {
        direction = 'Left',
        size = 0.1,
        cwd = project_dir,
    }
    -- may as well kick off a build in that pane
    editor_pane:send_text 'activate\nnvim .\nclear\n'
    build_pane:send_text 'activate\nclear\n'
    git_pane:send_text 'activate\ngit status\n'
end


wezterm.on('gui-startup', function(cmd)

    -- home
    default()
    -- projects
    projects()
    -- config
    config()

    -- phishing-detection
    project_workspace('phishing-detection', 'phishing-detection')
    -- autolure
    project_workspace('autolure', 'auto-lure-generation')
    -- titanhq-analytics
    project_workspace('titanhq-analytics', 'titanhq-analytics')

    mux.set_active_workspace 'home'
end)
