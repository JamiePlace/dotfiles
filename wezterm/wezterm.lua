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
	-- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
	{ key = '8', mods = 'CTRL', action = act.PaneSelect },
	-- activate pane selection mode with numeric labels
	{
		key = '9',
		mods = 'CTRL',
		action = act.PaneSelect {
			alphabet = '1234567890',
		},
	},
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
		action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},
	{
		key = ";",
		mods = 'CTRL',
		action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
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
	{ key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
}


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
config.color_scheme = 'Catppuccin Macchiato'
config.font = wezterm.font('Fira Code')
config.launch_menu = launch_menu
config.default_cursor_style = 'BlinkingBar'
config.disable_default_key_bindings = true
config.keys = keys
config.mouse_bindings = mouse_bindings
config.send_composed_key_when_left_alt_is_pressed = true
if not OnUnix() then
    config.initial_rows = 60
    config.initial_cols = 200
    config.font_size = 12
    config.window_background_image = "C:/Users/jamie/Pictures/wallpapers/portal.png"
    config.window_background_image_hsb = {
      -- Darken the background image by reducing it to 1/3rd
      brightness = 0.3,

      -- You can adjust the hue by scaling its value.
      -- a multiplier of 1.0 leaves the value unchanged.
      hue = 1,

      -- You can adjust the saturation also.
      saturation = 1,
    }
end

if OnUnix() then
    config.initial_rows = 50
    config.initial_cols = 180
    config.font_size = 16
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
return config
