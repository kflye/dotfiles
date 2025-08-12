#!/usr/bin/env bash

sudo pacman -S --needed wget curl git python3 \
	ripgrep fd bat fzf zoxide python-pip fish keychain \
	ninja gettext unzip lazygit starship \
    stow jq bc zellij neovim git-delta \


if [ ! -d "${HOME}/.local/bin" ]; then
	mkdir "${HOME}/.local/bin"
fi

if [ ! -d "${HOME}/.config" ]; then
	mkdir "${HOME}/.config/fish"
	mkdir "${HOME}/.config/fish/functions"
fi

clone_path="${clone_path:-"${PWD}"}"
echo "Current working directory: $clone_path"

if [ ! -f "${HOME}/.gitconfig.local" ]; then
	echo "copying .gitconfig.local"
	cp "${clone_path}/.gitconfig.local" "${HOME}/.gitconfig.local" 
fi

if ! command -v yay &> /dev/null; then
	echo "yay could not be found"
	sudo pacman -S --needed git base-devel 
	git clone https://aur.archlinux.org/yay.git 
	cd yay && makepkg -si && cd .. && rm -rf yay
fi
