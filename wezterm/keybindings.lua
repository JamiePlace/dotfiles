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

local function base_dir(path)
    local home = os.getenv("HOME")
    path = path:gsub("^~", home)
    return path
end

local function list_directories_with_pyproject(path)
    local dirs_with_pyproject = {}

    -- Read the contents of the base directory
    local entries = wezterm.read_dir(path)
    print("Entries: ", entries)
    if not entries then
        return dirs_with_pyproject
    end

    for _, entry in ipairs(entries) do
        local full_path = entry
        wezterm.log_info("Full Path: " .. full_path)
        local success, stdout, stderr = wezterm.run_child_process({"stat", "-F", full_path})
        wezterm.log_info("Attributes: ", success, stdout, stderr)
        wezterm.log_info("STDOUT: " .. stdout:sub(1, 1))
        if success and stdout:sub(1,1) == "d" then
            local pyproject_path = full_path .. "/pyproject.toml"
            local file = io.open(pyproject_path, "r")
            if file then
                table.insert(dirs_with_pyproject, full_path)
                file:close()
            end
        end
    end

    return dirs_with_pyproject
end

local function CreateWorkspace(name)
    return mux.create_workspace {
        name = name,
    }
end


local keys = {
    {
        key = '?',
        mods = 'CTRL|SHIFT',
        action = wezterm.action_callback(function(window, pane)
            local base_dir_path = base_dir("~/projects/")
            local project_dirs = list_directories_with_pyproject(base_dir_path)
            wezterm.log_info("Project Directories: ", project_dirs)
            local choices = {}
            for _, dir in ipairs(project_dirs) do
                table.insert(choices, { label = dir:gsub(base_dir_path, ""), id = dir})
            end

            window:perform_action(
                act.InputSelector({
                    title = "🎨 Pick a Project!",
                    choices = choices,
                    fuzzy = true,

                    action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
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
		action = wezterm.action.SplitHorizontal,
	},
	{
		key = ";",
		mods = 'CTRL',
		action = wezterm.action.SplitVertical,
	},
	{
		key = '0',
		mods = 'CTRL',
		action = wezterm.action.CloseCurrentPane { confirm = false },
	},
	{
		key = 'h',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.ActivatePaneDirection 'Left',
	},
	{
		key = 'l',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.ActivatePaneDirection 'Right',
	},
	{
		key = 'k',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.ActivatePaneDirection 'Up',
	},
	{
		key = 'j',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.ActivatePaneDirection 'Down',
	},
	{
		key = 'h',
		mods = 'ALT|SHIFT',
		action = wezterm.action.AdjustPaneSize {'Left', 5},
	},
	{
		key = 'l',
		mods = 'ALT|SHIFT',
		action = wezterm.action.AdjustPaneSize {'Right', 5},
	},
	{
		key = 'k',
		mods = 'ALT|SHIFT',
		action = wezterm.action.AdjustPaneSize {'Up', 5},
	},
	{
		key = 'j',
		mods = 'ALT|SHIFT',
		action = wezterm.action.AdjustPaneSize {'Down', 5},
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
    { key = ']', mods = 'ALT', action = act.SwitchWorkspaceRelative(1) },
    { key = '[', mods = 'ALT', action = act.SwitchWorkspaceRelative(-1) },
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
                    end),
                }),
                pane
            )
        end)
    },
    {
        key = 'T',
        mods = 'ALT|SHIFT',
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
                    end),
                }),
                pane
            )
        end)
    },
}
return keys
