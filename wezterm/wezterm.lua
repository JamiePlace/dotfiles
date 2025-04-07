-- The only required line is this one.
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local keys = require 'keybindings'
-- Some empty tables for later use
local config = {}
local mouse_bindings = {}
local launch_menu = {}

require "workspaces"

function OnUnix()
    if (package.config:sub(1,1)) == ("\\") then
        return false
    end
    return true
end

function RandomBackground()
	local directory = "Users/jamieplace/Pictures/backgrounds/"
	local i, t, popen = 0, {}, io.popen
	local pfile = popen('ls -a "'..directory..'"')
	if pfile == nil then
		return "nothing"
	end
	for filename in pfile:lines() do
		if filename == "." then
			goto continue
		end

		if filename == ".." then
			goto continue
		end

        if filename == ".DS_Store" then
            goto continue
        end
		i = i + 1
		if filename ~= nil or filename ~= directory  or filename ~= ".." or  filename ~= "." then
			t[i] = filename
		end
		::continue::
	end
	pfile:close()
	local rand = math.random(#t)
	return directory .. t[rand]
end

if not OnUnix() then
    if wezterm.config_builder then
      config = wezterm.config_builder()
    end
    config.default_domain = 'WSL:Ubuntu'
    wezterm.home_dir = '/home/jamie/'
end
config.color_scheme = "Rosé Pine (Gogh)"
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
  window:set_right_status(window:active_workspace() .. "   ")
end)


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
config.font = wezterm.font('Fira Code')
config.launch_menu = launch_menu
config.default_cursor_style = 'SteadyUnderline'
config.disable_default_key_bindings = true
config.keys = keys
config.mouse_bindings = mouse_bindings
config.send_composed_key_when_left_alt_is_pressed = true
config.exit_behavior = 'CloseOnCleanExit'
config.window_decorations = 'RESIZE'
if not OnUnix() then
    config.initial_rows = 50
    config.initial_cols = 180
    config.font_size = 13
    config.window_background_opacity = 1
    config.text_background_opacity = 1
end

if OnUnix() then
    config.initial_rows = 48
    config.initial_cols = 120
    config.font_size = 19
    --config.window_background_opacity = 1
    --config.text_background_opacity = 1

    ----config.window_background_image =  "/Users/jamieplace/Pictures/HD-wallpaper-kirby-sleeping.jpg"
    --config.window_background_image = RandomBackground()
    --config.window_background_image_hsb = {
    --    -- Darken the background image by reducing it to 1/3rd
    --    brightness = 0.025,

    --    -- You can adjust the hue by scaling its value.
    --    -- a multiplier of 1.0 leaves the value unchanged.
    --    hue = 1,

    --    -- You can adjust the saturation also.
    --    saturation = 0.1,
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
config.tab_bar_at_bottom = true
-- remove ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
-- ssh config
config.ssh_domains = {
    {
        name = 'JP-Analysis',
        remote_address = 'ec2-3-144-103-177.us-east-2.compute.amazonaws.com',
        username = 'ubuntu',
        ssh_option = {
            identityfile = '/Users/jamieplace/.ssh/ec2-key.pem',
        },
    },
}
return config

