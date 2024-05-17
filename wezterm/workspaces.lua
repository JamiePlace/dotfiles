local wezterm = require 'wezterm'
local mux = wezterm.mux

function default()
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'home',
        cwd = wezterm.home_dir,
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
        size = 0.8,
        cwd = project_dir,
    }
    local git_pane = editor_pane:split {
        direction = 'Right',
        size = 0.2,
        cwd = project_dir,
    }
    -- may as well kick off a build in that pane
    editor_pane:send_text 'activate\nnvim .\nclear\n'
    build_pane:send_text 'activate\nclear\n'
    git_pane:send_text 'activate\ngit pull\nlg\n'
end


wezterm.on('gui-startup', function(cmd)

    -- home
    default()
    -- config
    config()

    -- autolure
    project_workspace('autolure', 'auto-lure-generation')
    -- titanhq-analytics
    project_workspace('titanhq-analytics', 'titanhq-analytics')

    mux.set_active_workspace 'home'
end)
