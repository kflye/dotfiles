#!/usr/bin/env bash
#

#
# pacman -S sudo
# groupadd sudo
# Enable sudoers: nano /etc/sudoers and uncomment lines %wheel ALL=(ALL) NOPASSWD: ALL and %sudo   ALL=(ALL) ALL
# useradd -m -G wheel,sudo -s /bin/bash flye
# passwd flye
#
# Add to /etc/wsl.conf
# [user]
# default=flye
#

sudo pacman -S --needed wget curl python3 \
	ripgrep fd bat fzf zoxide python-pip fish keychain \
	ninja gettext unzip lazygit starship \
    stow jq bc zellij 


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