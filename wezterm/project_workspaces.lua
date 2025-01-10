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
    local project_dir = wezterm.home_dir .. base_dir .. dir
    local tab, build_pane, window = mux.spawn_window {
        workspace = name,
        cwd = project_dir,
    }
    build_pane:send_text 'activate\nclear\n'
end

-- generates works spaces for work computer
function workspaces.work()
    for dir in io.popen([[find $HOME/projects/ -maxdepth 2 -type f -name 'pyproject.toml' | xargs -I{} dirname {} | xargs -I{} basename {}]]):lines() do
        project_workspace(dir, dir, 'work')
    end
end

return workspaces
