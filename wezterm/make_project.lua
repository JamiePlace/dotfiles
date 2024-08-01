local tools = require 'tools'
local python_version = require 'python_version'
local workspace = require 'project_workspaces'

P = {}

local make_project
--Create python project based on given name
---@param name string
function make_project(name)
    local loc
    if tools.home_computer() then
        loc = os.getenv("HOME") .. "/myprojects/"
    else
        if tools.on_unix() then
            loc = os.getenv("HOME") .. "/projects/"
        else
            loc = "C:\\Users\\jamie\\projects\\"
        end
    end

    if tools.on_unix() then
        os.execute('cd ' .. loc .. ' && rye init ' .. name .. ' && cd ' .. name .. ' && rye pin ' .. python_version[1] .. ' && rye sync')
    else
        os.execute('powershell "cd ' .. loc .. '; rye init ' .. name .. '; cd ' .. name .. '; rye pin ' .. python_version[1] .. '; rye sync"')
    end

    if tools.home_computer() then
        workspace.home()
    else
        workspace.work()
    end
end

P.make_project = make_project
return P
