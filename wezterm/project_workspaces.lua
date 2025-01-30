local wezterm = require 'wezterm'
local tools = require 'tools'
local mux = wezterm.mux

local workspaces = {}

if not tools.on_unix() then
    wezterm.home_dir = '/home/jamie/'
end

local
function project_workspace(name, dir, loc)
    local base_dir = "/projects/"
    if loc == 'work' then
        local project_dir = wezterm.home_dir .. base_dir .. dir
    else
        local project_dir = "/home/jamie" .. base_dir .. dir
    end
    local tab, build_pane, window = mux.spawn_window {
        workspace = name,
        cwd = project_dir,
    }
    build_pane:send_text 'activate\nclear\n'
end

-- generates works spaces for work computer
function workspaces.work()
    print('Generating work workspaces')
    for dir in io.popen([[find $HOME/projects/ -maxdepth 2 -type f -name 'pyproject.toml' | xargs -I{} dirname {} | xargs -I{} basename {}]]):lines() do
        print(dir)
        if not tools.on_unix() then
            project_workspace(dir, dir, 'home')
        else
            project_workspace(dir, dir, 'work')
        end
    end
end

return workspaces
