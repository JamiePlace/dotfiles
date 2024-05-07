#!/usr/local/bin lua

local lines_from
--get all lines from a file
---@param file string file to read text from 
---@returns returns an empty table list/table if the file does not exist
function lines_from(file)
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

local is_lua_comment
---@param line string
---@return boolean
function is_lua_comment(line)
    local start, _ = string.find(line, "^%-%-")
    return start ~= nil
end

local remove_comment
---@param line string
---@return string
function remove_comment(line)
    return line:sub(3)
end

local add_comment
---@param line string
---@return string
function add_comment(line)
    return "--" .. line
end

local nvim_colour
-- update the colour of nvim to light or dark
function nvim_colour()
    local file_path = os.getenv("HOME") .. '/.config/nvim/lua/jamie/colours.lua'
    -- read the lines from the file
    local nvim_mode = lines_from(file_path)
    -- print all line numbers and their contents
    local light
    local dark
    light, dark = not is_lua_comment(nvim_mode[1]), not is_lua_comment( nvim_mode[2] )

    local line1
    local line2
    if light then
        line1 = add_comment(nvim_mode[1])
        line2 = remove_comment(nvim_mode[2])
    end
    if dark then
        line1 = remove_comment(nvim_mode[1])
        line2 = add_comment(nvim_mode[2])
    end

    nvim_mode[1] = line1
    nvim_mode[2] = line2

    local file = io.open(file_path, "w")
    for _, v in pairs(nvim_mode) do
        if file ~= nil then file:write(v .. "\n") end
    end
    if file ~= nil then file:close() end
end

local wezterm_colour
-- update the colour of wezterm to light or dark
function wezterm_colour()
    local file_path = os.getenv("HOME") .. '/.config/wezterm/wezterm.lua'
    -- read the lines from the file
    local wezterm_mode = lines_from(file_path)
    -- print all line numbers and their contents
    local light
    local dark
    light, dark = not is_lua_comment(wezterm_mode[10]), not is_lua_comment( wezterm_mode[11] )

    local line1
    local line2
    if light then
        line1 = add_comment(wezterm_mode[10])
        line2 = remove_comment(wezterm_mode[11])
    end
    if dark then
        line1 = remove_comment(wezterm_mode[10])
        line2 = add_comment(wezterm_mode[11])
    end

    wezterm_mode[10] = line1
    wezterm_mode[11] = line2

    local file = io.open(file_path, "w")
    for _, v in pairs(wezterm_mode) do
        if file ~= nil then file:write(v .. "\n") end
    end
    if file ~= nil then file:close() end
end

local main
function main()
    nvim_colour()
    wezterm_colour()
end

main()
