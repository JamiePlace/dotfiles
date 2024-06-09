local wezterm = require 'wezterm'
local mux = wezterm.mux

local workspaces = {}

function project_workspace(name, dir, loc)
    local base_dir
    if loc == 'work' then
        base_dir = "/projects/"
    else
        base_dir = "/myprojects/"
    end
    local project_dir = wezterm.home_dir .. base_dir .. dir
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

-- generates works spaces for work computer
function workspaces.work()
    for dir in io.popen([[find $HOME/projects/ -maxdepth 2 -type f -name 'pyproject.toml' | xargs -I{} dirname {} | xargs -I{} basename {}]]):lines() do
        project_workspace(dir, dir, 'work')
    end
end

-- generates works spaces for home computer
function workspaces.home()
    for dir in io.popen([[find $HOME/myprojects/ -maxdepth 2 -type f -name 'pyproject.toml' | xargs -I{} dirname {} | xargs -I{} basename {}]]):lines() do
        project_workspace(dir, dir, 'home')
    end
end

return workspaces
