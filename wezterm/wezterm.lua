-- The only required line is this one.
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
-- Some empty tables for later use
local config = {}
local mouse_bindings = {}
local launch_menu = {}

function OnUnix()
    if (package.config:sub(1,1)) == ("\\") then
        return false
    end
    return true
end

local keys = {
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		key = '0',
		mods = 'CTRL',
		action = act.PaneSelect {
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
		action = act.ActivatePaneDirection 'Left',
	},
	{
		key = 'l',
		mods = 'CTRL',
		action = act.ActivatePaneDirection 'Right',
	},
	{
		key = 'k',
		mods = 'CTRL',
		action = act.ActivatePaneDirection 'Up',
	},
	{
		key = 'j',
		mods = 'CTRL',
		action = act.ActivatePaneDirection 'Down',
	},
	{
		key = 'h',
		mods = 'CTRL|SHIFT',
		action = act.AdjustPaneSize {'Left', 5},
	},
	{
		key = 'l',
		mods = 'CTRL|SHIFT',
		action = act.AdjustPaneSize {'Right', 5},
	},
	{
		key = 'k',
		mods = 'CTRL|SHIFT',
		action = act.AdjustPaneSize {'Up', 5},
	},
	{
		key = 'j',
		mods = 'CTRL|SHIFT',
		action = act.AdjustPaneSize {'Down', 5},
	},
	{ key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
	{ key = 't', mods = 'ALT', action = wezterm.action.SpawnTab 'DefaultDomain' },
    -- entering copy mode
    { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCopyMode },
    -- workspaces
    {
        key = 'y',
        mods = 'CTRL|SHIFT',
        action = act.SwitchToWorkspace {
            name = 'default',
        },
    },
    -- Switch to a monitoring workspace, which will have `top` launched into it
    {
        key = 'u',
        mods = 'CTRL|SHIFT',
        action = act.SwitchToWorkspace {
            name = 'monitoring',
            spawn = {
                args = { 'nvidia-smi' },
            },
        },
    },
    -- Create a new workspace with a random name and switch to it
    { key = 'i', mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace },
    -- Show the launcher in fuzzy selection mode and have it list all workspaces
    -- and allow activating one.
    {
        key = '9',
        mods = 'ALT',
        action = act.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
        },
    },
}

wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)
if not OnUnix() then
    --- Set Pwsh as the default on Windows
    config.default_prog = { 'powershell', '-NoLogo' }
end

mouse_bindings = {
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
            end
        end),
    },
}

--- Default config settings
config.color_scheme = 'tokyonight'
config.font = wezterm.font('Fira Code')
config.launch_menu = launch_menu
config.default_cursor_style = 'BlinkingBar'
config.disable_default_key_bindings = true
config.keys = keys
config.mouse_bindings = mouse_bindings
config.send_composed_key_when_left_alt_is_pressed = true
config.exit_behavior = 'Hold'
if not OnUnix() then
    config.initial_rows = 50
    config.initial_cols = 180
    config.font_size = 14
    config.window_background_opacity = 0.85
    config.text_background_opacity = 1
end

if OnUnix() then
    config.initial_rows = 50
    config.initial_cols = 180
    config.font_size = 16
    config.window_background_opacity = 0.85
    config.text_background_opacity = 0.5
    --config.window_background_image = "/Users/jamieplace/Pictures/mystic_mountain.png"
    --config.window_background_image_hsb = {
    --    -- Darken the background image by reducing it to 1/3rd
    --    brightness = 0.15,

    --    -- You can adjust the hue by scaling its value.
    --    -- a multiplier of 1.0 leaves the value unchanged.
    --    hue = 1,

    --    -- You can adjust the saturation also.
    --    saturation = 1,
    --}
end

for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
end
-- remove ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
return config
