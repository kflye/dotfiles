#!/usr/bin/env fish
#
# fractional scaling gnome :  gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']" 

if [[ -z "$XDG_CONFIG_HOME" ]]; then
	echo $XDG_CONFIG_HOME
	echo ´XDG_CONFIG_HOME not set´
	# exit 1
fi

echo $XDG_CONFIG_HOME

# sudo apt install ripgrep fd-find fzf zoxide python3-pip

clone_path="${clone_path:-"${PWD}"}"
echo "Current working directory: $clone_path"

rm -rf ~/.config/nvim;
ln -fs "${clone_path}/nvim" "${HOME}/.config/nvim"


ln -fs "${clone_path}/starship/starship.toml" "${HOME}/.config/starship.toml"

# git
ln -fs "${clone_path}/git/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${clone_path}/git/.gitignore" "${HOME}/.gitignore"
ln -fs "${clone_path}/git/.gitattributes" "${HOME}/.gitattributes"

cp "${clone_path}/git/.gitconfig.local" "${HOME}/.gitconfig.local" 

# New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitconfig -Target $path\.gitconfig;
# New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitignore -Target $path\.gitignore
# New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitattributes -Target $path\.gitattributes


