local wezterm = require 'wezterm'
local act = wezterm.action
local tools = require 'tools'
local workspace = require 'project_workspaces'

local keys = {
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
        key = '9',
        mods = 'ALT',
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
                    },
                    pane
                    )
                end
            end),
        },
    },
    -- Prompt for a name to use for a new workspace and switch to it.
    {
        key = 'P',
        mods = 'CTRL|SHIFT',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Aqua' } },
                { Text = '  python project name ' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    print(line)
                    local loc
                    if tools.home_computer() then
                        loc = os.getenv("HOME") .. "/myprojects/"
                    else
                        loc = os.getenv("HOME") .. "/projects/"
                    end

                    os.execute('cd ' .. loc .. ' && rye init ' .. line .. ' && cd ' .. line .. ' && rye pin ' .. tools.ptyhon_version .. ' && rye sync')

                    if tools.home_computer() then
                        workspace.home()
                    else
                        if tools.on_unix() then
                            workspace.work()
                        else
                            workspace.home_windows()
                        end
                    end
                    window:perform_action(
                        act.SwitchToWorkspace {
                            name = line,
                        },
                        pane
                    )
                end
            end),
        },
    },
}
return keys
