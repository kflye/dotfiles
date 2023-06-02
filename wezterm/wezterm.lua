local wezterm = require 'wezterm'
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = 'Light'})
config.color_scheme = 'tokyonight_storm'
--config.color_scheme = "Gruvbox dark, medium (base16)"

--config.default_prog = { '/usr/bin/pwsh', '-l' }

return config
