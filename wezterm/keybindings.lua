local wezterm = require 'wezterm'

local keys = {
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		key = '0',
		mods = 'CTRL',
		action = wezterm.action.PaneSelect {
			mode = 'SwapWithActive',
		},
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
		action = wezterm.action.CloseCurrentPane { confirm = true },
	},
	{
		key = 'h',
		mods = 'CTRL',
		action = wezterm.action.ActivatePaneDirection 'Left',
	},
	{
		key = 'l',
		mods = 'CTRL',
		action = wezterm.action.ActivatePaneDirection 'Right',
	},
	{
		key = 'k',
		mods = 'CTRL',
		action = wezterm.action.ActivatePaneDirection 'Up',
	},
	{
		key = 'j',
		mods = 'CTRL',
		action = wezterm.action.ActivatePaneDirection 'Down',
	},
	{
		key = 'h',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.AdjustPaneSize {'Left', 5},
	},
	{
		key = 'l',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.AdjustPaneSize {'Right', 5},
	},
	{
		key = 'k',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.AdjustPaneSize {'Up', 5},
	},
	{
		key = 'j',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.AdjustPaneSize {'Down', 5},
	},
	{ key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
	{ key = 't', mods = 'ALT', action = wezterm.action.SpawnTab 'DefaultDomain' },
    -- entering copy mode
    { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCopyMode },
    -- workspaces
    -- Switch to a file explorer workspace using yazi
    {
        key = 'y',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SwitchToWorkspace {
            name = 'monitoring',
            spawn = {
                args = { 'ya()' },
            },
        },
    },
    -- Show the launcher in fuzzy selection mode and have it list all workspaces
    -- and allow activating one.
    {
        key = '9',
        mods = 'ALT',
        action = wezterm.action.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
        },
    },
    { key = 'p', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
}
return keys
