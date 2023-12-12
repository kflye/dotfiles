#!/usr/bin/env bash


if command -v nvim &> /dev/null
then
    echo $'nvim already installed'
    echo "$(nvim --version)"
    exit
fi

git clone https://github.com/neovim/neovim ~/neovim

cd ~/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install