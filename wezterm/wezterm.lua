local wezterm = require 'wezterm'
-- This table will hold the configuration.

local config = wezterm.config_builder()

config.font = wezterm.font("RedHatMono Nerd Font", { weight = 'Light' })
-- config.color_scheme = 'tokyonight_storm'
config.color_scheme = "Gruvbox dark, medium (base16)"
-- config.color_scheme = 'catppuccin-macchiato'
-- config.color_scheme = 'Kanagawa (Gogh)'

--
config.leader = { key = "b", mods = "CTRL" }
config.keys = {
    { key = "-",  mods = "LEADER", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "\\", mods = "LEADER", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
    { key = "z",  mods = "LEADER", action = "TogglePaneZoomState" },
    { key = "c",  mods = "LEADER", action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },
}

local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { 'pwsh.exe', '-NoLogo' }
    table.insert(launch_menu, {
        label = 'PowerShell',
        args = { 'pwsh.exe', '-NoLogo' },
    })
end

config.launch_menu = launch_menu
return config
