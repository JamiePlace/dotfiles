local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux
local tools = require 'tools'
local workspace = require 'project_workspaces'

ConfigPath = function ()
    if tools.home_computer() then
        return "/C/Users/jamie/.config/wezterm/wezterm.lua"
    else
        return "/Users/jamieplace/.config/wezterm/wezterm.lua"
    end
end

local function is_nvim(pane)
    local process_name = pane:get_foreground_process_name()
    print("proces name:" .. process_name)
    if process_name == nil then
        return false
    end
    if string.find(process_name, "nvim") then
        print("NVIM FOUND!")
        return true
    end
    return false

end

local function base_dir(path)
    local home = os.getenv("HOME")
    if not home then
        home = "\\\\wsl.localhost\\Ubuntu\\home\\jamie"
    end
    path = path:gsub("^~", home)
    return path
end

local process_icons = {
    ['.dockerfile'] = wezterm.nerdfonts.linux_docker,
    ['Dockerfile'] = wezterm.nerdfonts.linux_docker,
    ['node'] = wezterm.nerdfonts.mdi_hexagon,
    ['go.mod'] = wezterm.nerdfonts.seti_go,
    ['.venv'] = '',
    ['pyrpoject.toml'] = '',
    ['zsh'] = wezterm.nerdfonts.dev_terminal,
    ['cargo'] = wezterm.nerdfonts.dev_rust,
    ['.git'] = wezterm.nerdfonts.dev_git,
    ['.lua'] = wezterm.nerdfonts.seti_lua,
}

local function contains(table, element)
    for _, value in pairs(table) do
        if string.find(value, element) then
            return true
        end
    end
    return false
end

local function dir_symbol(path, base_dir_path)
    local entries = wezterm.read_dir(path)
    local symbols = {}
    local seen_process_icons = {}
    for key, value in pairs(process_icons) do
        print("Key: ", key)
        if contains(entries, key) then
            if not seen_process_icons[key] then
                table.insert(symbols, process_icons[key])
                seen_process_icons[key] = true
            end
        end
    end
    print("Path: ", path)
    print("Symbols: ", symbols)
    return "[" .. table.concat(symbols, ", ") .. "]" .. " " .. path:gsub(base_dir_path, "")
end

local function list_directories_with_git(path)
    local home = os.getenv("HOME")
    local dirs_with_git = {}

    -- Read the contents of the base directory
    local entries = wezterm.read_dir(path)
    print("Entries: ", entries)
    if not entries then
        print("No entries found")
        return dirs_with_git
    end

    for _, entry in ipairs(entries) do
        local full_path = entry
        wezterm.log_info("****************")
        wezterm.log_info("Full Path: " .. full_path)
        local success, stdout, stderr
        if not home then
            success, stdout, stderr = wezterm.run_child_process({"stat",  full_path})
        else
            success, stdout, stderr = wezterm.run_child_process({"stat", "-F", full_path})
        end
        wezterm.log_info("Attributes: ", success, stdout, stderr)
        wezterm.log_info("STDOUT: " .. stdout)
        if not home then
            local pattern = "[d-][r-][w-][x-][r-][w-][x-][r-][w-][x-]"
            for match in string.gmatch(stdout, pattern) do
                wezterm.log_info("Match: ", match)
                if success and match:sub(1,1) == "d" then
                    wezterm.log_info("Directory: ", full_path)
                    local pyproject_path = full_path .. "/.git/HEAD"
                    local file = io.open(pyproject_path, "r")
                    if file then
                        table.insert(dirs_with_git, full_path)
                        file:close()
                    end
                end
            end
        else
            wezterm.log_info("STDOUT: " .. stdout:sub(1, 1))
            if success and stdout:sub(1, 1) == "d" then
                wezterm.log_info("Directory: ", full_path)
                local pyproject_path = full_path .. "/.git/HEAD"
                local file = io.open(pyproject_path, "r")
                if file then
                    table.insert(dirs_with_git, full_path)
                    file:close()
                end
            end
        end
    end

    return dirs_with_git
end

wezterm.on('workspace-changed', function(window, pane, info)
  if info.old_workspace ~= info.new_workspace then
    wezterm.GLOBAL.previous_workspace = info.old_workspace
  end
end)

local keys = {
    {
        key = '?',
        mods = 'CTRL|SHIFT',
        action = wezterm.action_callback(function(window, pane)
            local base_dir_path = base_dir("~/projects/")
            print("Base Dir Path: ", base_dir_path)
            --local project_dirs = list_directories_with_pyproject(base_dir_path)
            local project_dirs = list_directories_with_git(base_dir_path)
            wezterm.log_info("Project Directories: ", project_dirs)
            local choices = {}
            for _, dir in ipairs(project_dirs) do
                print("Dir: ", dir)
                if dir~=nil then
                    table.insert(choices, { label = dir_symbol(dir, base_dir_path), id = dir})
                end
            end

            window:perform_action(
                act.InputSelector({
                    title = "🎨 Pick a Project!",
                    choices = choices,
                    fuzzy = true,

                    action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
                        if label~=nil then
                            inner_window:perform_action(
                                act.SwitchToWorkspace({
                                    name = label,
                                    spawn = {
                                        label = "Workspace: " .. label,
                                        cwd = id,
                                    },
                                }),
                                inner_pane
                            )
                        end
                    end),
                }),
                pane
            )
        end)
    },
    {
        key = '|',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ShowDebugOverlay,
    },
	-- This will create a new split and run your default program inside it
	{
		key = "'",
		mods = 'CTRL',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = "'", mods = 'CTRL'},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.SplitHorizontal,
                    pane
                )
            end
        end),
	},
	{
		key = ";",
		mods = 'CTRL',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = ";", mods = 'CTRL'},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.SplitVertical,
                    pane
                )
            end
        end),
	},
	{
		key = '0',
		mods = 'CTRL',
		action = wezterm.action.CloseCurrentPane { confirm = false },
	},
	{
		key = 'h',
		mods = 'CTRL|SHIFT',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = "w", mods = 'CTRL'},
                    pane
                )
                window:perform_action(
                    wezterm.action.SendKey { key = "h"},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.ActivatePaneDirection 'Left',
                    pane
                )
            end
        end),
	},
	{
		key = 'l',
		mods = 'CTRL|SHIFT',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = "w", mods = 'CTRL'},
                    pane
                )
                window:perform_action(
                    wezterm.action.SendKey { key = "l"},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.ActivatePaneDirection 'Right',
                    pane
                )
            end
        end),
	},
	{
		key = 'k',
		mods = 'CTRL|SHIFT',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = "w", mods = 'CTRL'},
                    pane
                )
                window:perform_action(
                    wezterm.action.SendKey { key = "k"},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.ActivatePaneDirection 'Up',
                    pane
                )
            end
        end),
	},
	{
		key = 'j',
		mods = 'CTRL|SHIFT',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = "w", mods = 'CTRL'},
                    pane
                )
                window:perform_action(
                    wezterm.action.SendKey { key = "j"},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.ActivatePaneDirection 'Down',
                    pane
                )
            end
        end),
	},
	{
		key = 'h',
		mods = 'ALT|SHIFT',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = "h", mods = 'ALT|SHIFT'},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.AdjustPaneSize {'Left', 5},
                    pane
                )
            end
        end),
	},
	{
		key = 'l',
		mods = 'ALT|SHIFT',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = "l", mods = 'ALT|SHIFT'},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.AdjustPaneSize {'Right', 5},
                    pane
                )
            end
        end),
	},
	{
		key = 'k',
		mods = 'ALT|SHIFT',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = "k", mods = 'ALT|SHIFT'},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.AdjustPaneSize {'Up', 5},
                    pane
                )
            end
        end),
	},
	{
		key = 'j',
		mods = 'ALT|SHIFT',
		action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(
                    wezterm.action.SendKey { key = "j", mods = 'ALT|SHIFT'},
                    pane
                )
            else
                window:perform_action(
                    wezterm.action.AdjustPaneSize {'Down', 5},
                    pane
                )
            end
        end),
	},
	{ key = 'l', mods = 'CTRL|ALT', action = wezterm.action.ShowLauncher },
	{ key = 't', mods = 'ALT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    -- entering copy mode
    { key = 'v', mods = 'ALT', action = wezterm.action.ActivateCopyMode },
    -- Show the launcher in fuzzy selection mode and have it list all workspaces
    -- and allow activating one.
    {
        key = '(',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
        },
    },
    { key = 'q', mods = 'ALT', action = wezterm.action.QuitApplication },
    { key = 'p', mods = 'ALT', action = wezterm.action.PasteFrom 'Clipboard' },
    { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
    {
        key = ']', mods = 'ALT', action = wezterm.action_callback(
            function(window, pane)
                -- select workspace form GLOBAL.previous_workspace
                if wezterm.GLOBAL.previous_workspace then
                    window:perform_action(
                        act.SwitchToWorkspace {
                            name = wezterm.GLOBAL.previous_workspace,
                        }, pane)
                else
                    wezterm.log_info("No previous workspace found")
                end
            end
        )
    },
    -- Prompt for a name to use for a new workspace and switch to it.
    {
        key = 'W',
        mods = 'CTRL|SHIFT',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter name for new workspace' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:perform_action(
                    act.SwitchToWorkspace {
                        name = line,
                    }, pane)
                end
            end),
        },
    },
    {
        key = 'T',
        mods = 'CTRL|SHIFT',
        action = wezterm.action_callback(function(window, pane)
            -- get builting color schemes
            local schemes = wezterm.get_builtin_color_schemes()
            local choices = {}

            -- populate theme names in choices list
            for key, _ in pairs(schemes) do
                table.insert(choices, { label = tostring(key) })
            end

            -- sort choices list
            table.sort(choices, function(c1, c2)
                return c1.label < c2.label
            end)

            window:perform_action(
                act.InputSelector({
                    title = "🎨 Pick a Theme!",
                    choices = choices,
                    fuzzy = true,

                    -- execute 'sed' shell command to replace the line 
                    -- responsible of colorscheme in my config
                    action = wezterm.action_callback(function(inner_window, inner_pane, _, label)
                        if not os.getenv("HOME") then
                            inner_window:perform_action(
                                act.SpawnCommandInNewTab({
                                    args = {
                                        "sed",
                                        "-i",
                                        's/config.color_scheme =.*/config.color_scheme = "' .. label .. '"/',
                                        "/home/jamie/.config/wezterm/wezterm.lua",
                                    },
                                }),
                                inner_pane
                            )
                        else
                            inner_window:perform_action(
                                act.SpawnCommandInNewTab({
                                    args = {
                                        "sed",
                                        "-i",
                                        "",
                                        's/config.color_scheme =.*/config.color_scheme = "' .. label .. '"/',
                                        '/Users/jamieplace/.config/wezterm/wezterm.lua',
                                    },
                                }),
                                inner_pane
                            )
                        end
                    end),
                }),
                pane
            )
        end)
    },
}
return keys
