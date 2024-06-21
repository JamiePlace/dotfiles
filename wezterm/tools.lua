local python_version = "3.10"
local home_computer

function OnUnix()
    if (package.config:sub(1,1)) == ("\\") then
        return false
    end
    return true

end

-- Check if the computer is a home computer
---@rtype boolean
function home_computer()
    local directory
    if OnUnix() then
        directory = os.getenv("HOME")
    else
        directory = "C:\\Users\\jamie"
    end

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


local m = {
    home_computer = home_computer,
    on_unix = OnUnix,
    ptyhon_version = python_version
}
return m
