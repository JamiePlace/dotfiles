-- The only required line is this one.
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local keys = require 'keybindings'
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
