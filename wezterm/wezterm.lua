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

local process_icons = {
  ['docker'] = wezterm.nerdfonts.linux_docker,
  ['docker-compose'] = wezterm.nerdfonts.linux_docker,
  ['psql'] = '󱤢',
  ['usql'] = '󱤢',
  ['kuberlr'] = wezterm.nerdfonts.linux_docker,
  ['ssh'] = wezterm.nerdfonts.fa_exchange,
  ['ssh-add'] = wezterm.nerdfonts.fa_exchange,
  ['kubectl'] = wezterm.nerdfonts.linux_docker,
  ['stern'] = wezterm.nerdfonts.linux_docker,
  ['nvim'] = wezterm.nerdfonts.custom_vim,
  ['make'] = wezterm.nerdfonts.seti_makefile,
  ['vim'] = wezterm.nerdfonts.dev_vim,
  ['node'] = wezterm.nerdfonts.mdi_hexagon,
  ['go'] = wezterm.nerdfonts.seti_go,
  ['python3'] = '',
  ['zsh'] = wezterm.nerdfonts.dev_terminal,
  ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
  ['btm'] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ['htop'] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ['cargo'] = wezterm.nerdfonts.dev_rust,
  ['sudo'] = wezterm.nerdfonts.fa_hashtag,
  ['lazydocker'] = wezterm.nerdfonts.linux_docker,
  ['git'] = wezterm.nerdfonts.dev_git,
  ['lua'] = wezterm.nerdfonts.seti_lua,
  ['wget'] = wezterm.nerdfonts.mdi_arrow_down_box,
  ['curl'] = wezterm.nerdfonts.mdi_flattr,
  ['gh'] = wezterm.nerdfonts.dev_github_badge,
  ['ruby'] = wezterm.nerdfonts.cod_ruby,
}

wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)

function Basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local title = Basename(pane.foreground_process_name)
      .. ' '
      .. pane.pane_id
    local color = 'None'
    if tab.is_active then
      color = '#B25400'
    end
    return {
      { Background = { Color = color } },
      { Text = ' ' .. title .. ' ' },
    }
  end
)

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
config.color_scheme ='Catppuccin Latte (Gogh)'
--config.color_scheme ='Vs Code Dark+ (Gogh)'
config.font = wezterm.font('JetBrains Mono')
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
    config.window_background_opacity = 1
    config.text_background_opacity = 1
end

if OnUnix() then
    config.initial_rows = 48
    config.initial_cols = 80
    config.font_size = 16
    config.window_background_opacity = 1
    config.text_background_opacity = 1

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
