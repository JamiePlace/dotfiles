local home_computer
-- Check if the computer is a home computer
---@rtype boolean
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

local m = {
    home_computer = home_computer,
}
return m
