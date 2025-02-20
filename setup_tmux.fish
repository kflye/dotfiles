#!/usr/bin/env fish

if test ! -d ~/.tmux/plugins/tpm
    echo "cloning tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
end

if test ! -d ~/tmux-mem-cpu-load
    echo "cloning tmux-mem-cpu-load"
    git clone https://github.com/thewtex/tmux-mem-cpu-load.git ~/tmux-mem-cpu-load
    cd ~/tmux-mem-cpu-load
    cmake .
    make
    sudo make install
end
