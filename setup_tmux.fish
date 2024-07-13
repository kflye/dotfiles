#!/usr/bin/env fish

if test ! -d ~/.tmux/plugins/tpm
    echo "cloning tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
end
