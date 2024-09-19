local wezterm = require 'wezterm'
local act = wezterm.action
local tools = require 'tools'
local workspace = require 'project_workspaces'

ConfigPath = function ()
    if tools.home_computer() then
        return "/C/Users/jamie/.config/wezterm/wezterm.lua"
    else
        return "/Users/jamieplace/.config/wezterm/wezterm.lua"
    end
end

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
                    },
                    pane
                    )
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
                                    ConfigPath(),
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
        key = 'G',
        mods = 'CTRL|SHIFT',
        action = act.SpawnCommandInNewTab({
            args = {
                "git",
                "commit"
            },
        })
    }
}
return keys
