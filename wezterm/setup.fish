#!/usr/bin/env fish

set DIR (realpath (dirname (status --current-filename)))

ln -fs "$DIR/wezterm.lua" "$HOME/.wezterm.lua"
