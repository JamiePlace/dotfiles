local wezterm = require 'wezterm'
local mux = wezterm.mux

local function home()
    if not os.getenv("HOME") then
        return "\\\\wsl.localhost\\Ubuntu\\home\\jamie"
    else
        return os.getenv("HOME")
    end
end

local function default()
    local tab, build_pane, window = mux.spawn_window {
        workspace = '🏠 home',
        cwd = home(),
    }
end

local function config()
    local tab, build_pane, window = mux.spawn_window {
        workspace = '🔧 config',
        cwd = wezterm.home_dir .. "/.config",
    }
end

local function Pobsidian()
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'Λ Obsidian - Personal',
        cwd = wezterm.home_dir .. "/notes" .. "/personal",
    }
end

local function Wobsidian()
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'λ Obsidian - Work',
        cwd = wezterm.home_dir .. "/notes" .. "/work",
    }
end

local function projects()
    local tab, build_pane, window = mux.spawn_window {
        workspace = '📚 projects',
        cwd = wezterm.home_dir .. "/projects",
    }
end

wezterm.on('gui-startup', function(cmd)
    -- home
    default()
    -- config
    config()
    -- obsidian
    Pobsidian()
    --Wobsidian()
    -- projects
    projects()
    mux.set_active_workspace 'home'
end)
