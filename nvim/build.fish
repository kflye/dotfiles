#!/usr/bin/env fish

if command -q nvim
    echo 'nvim already installed'
    echo (nvim --version)
    exit
end

git clone https://github.com/neovim/neovim ~/neovim

cd ~/neovim 

git checkout master

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install
