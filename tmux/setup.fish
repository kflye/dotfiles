#!/usr/bin/env fish

if test ! -d ~/.tmux/plugins/tpm
    echo "cloning tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
end

set DIR (realpath (dirname (status --current-filename)))

ln -fs "$DIR/.tmux.conf" "$HOME/.tmux.conf"
