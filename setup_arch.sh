#!/usr/bin/env bash
#
# fractional scaling gnome :  gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']" 

if [[ -z "$XDG_CONFIG_HOME" ]]; then
	echo $XDG_CONFIG_HOME
	echo ´XDG_CONFIG_HOME not set´
	# exit 1
fi

echo $XDG_CONFIG_HOME

# sudo add-apt-repository ppa:git-core/ppa
# sudo apt-add-repository ppa:fish-shell/release-3


sudo pacman -S ripgrep fd bat fzf zoxide python-pip fish git keychain ninja gettext cmake unzip curl lazygit starship wget \
    stow jq bc


if [ ! -d "${HOME}/.local/bin" ]; then
	mkdir "${HOME}/.local/bin"
fi


if [ ! -d "${HOME}/.config" ]; then
	mkdir "${HOME}/.config/fish"
	mkdir "${HOME}/.config/fish/functions"
fi

if ! command -v nvm &> /dev/null; then
	echo "nvm could not be found"
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

clone_path="${clone_path:-"${PWD}"}"
echo "Current working directory: $clone_path"

rm -rf ~/.config/nvim;
ln -fs "${clone_path}/nvim" "${HOME}/.config/nvim"


ln -fs "${clone_path}/starship/starship.toml" "${HOME}/.config/starship.toml"
ln -fs "${clone_path}/fish/config.fish" "${HOME}/.config/fish/config.fish"
ln -fs "${clone_path}/fish/themes" "${HOME}/.config/fish"
ln -fs "${clone_path}/fish/functions/" "${HOME}/.config/fish/" # TODO: Not testet

# git
ln -fs "${clone_path}/git/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${clone_path}/git/.gitignore" "${HOME}/.gitignore"
ln -fs "${clone_path}/git/.gitattributes" "${HOME}/.gitattributes"

if [ ! -f "${HOME}/.gitconfig.local" ]; then
	echo "copying .gitconfig.local"
	cp "${clone_path}/git/.gitconfig.local" "${HOME}/.gitconfig.local" 
fi


./fish/setup.sh
