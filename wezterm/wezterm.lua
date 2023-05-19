local wezterm = require 'wezterm'

return {
    font = wezterm.font("JetBrainsMono Nerd Font", { weight = 'Light'}),
    color_scheme = "Gruvbox dark, medium (base16)",

   default_prog = { '/usr/bin/pwsh', '-l' },
}