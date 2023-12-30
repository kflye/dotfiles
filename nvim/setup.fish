#!/usr/bin/env fish

rm -rf ~/.config/nvim 

set DIR (realpath (dirname (status --current-filename)))

ln -fs "$DIR" "$HOME/.config/nvim"
