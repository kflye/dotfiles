#!/usr/bin/env bash
#
# fractional scaling gnome :  gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']" 

if [[ -z "$XDG_CONFIG_HOME" ]]; then
	echo $XDG_CONFIG_HOME
	echo ´XDG_CONFIG_HOME not set´
	# exit 1
fi

echo $XDG_CONFIG_HOME

sudo add-apt-repository ppa:git-core/ppa
sudo apt-add-repository ppa:fish-shell/release-3


sudo apt install ripgrep fd-find bat zoxide python3-pip fish git keychain \
	ninja-build gettext cmake unzip curl \
    stow jq bc gnome-keyring

if ! command -v rustup &> /dev/null; then
	echo "rustup could not be found"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source $HOME/.cargo/env
fi

if ! command -v zellij &> /dev/null; then
	echo "zellij could not be found"
	cargo install --locked zellij
fi

if ! command -v lazygit &> /dev/null; then
	echo "lazygit could not be found"
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
	rm lazygit
	rm lazygit.tar.gz
fi

if [ ! -d "${HOME}/.local/bin" ]; then
	mkdir "${HOME}/.local/bin"
fi

if ! command -v fd &> /dev/null; then
	echo "fd could not be found"
	ln -fs $(which fdfind) ~/.local/bin/fd
fi

if ! command -v bat &> /dev/null; then
	echo "bat could not be found"
	ln -fs $(which batcat) ~/.local/bin/bat
fi

if ! command -v starship &> /dev/null; then
    echo "starship could not be found"
	curl -sS https://starship.rs/install.sh | sh
fi

if ! command -v fzf &> /dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --no-bash --no-zsh
fi

./setup_fish.sh
