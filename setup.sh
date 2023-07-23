#!/usr/bin/env fish

if [[ -z "$XDG_CONFIG_HOME" ]]; then
	echo $XDG_CONFIG_HOME
	echo ´XDG_CONFIG_HOME not set´
	exit 1
fi

echo $XDG_CONFIG_HOME

sudo apt install fish ripgrep fd-find fzf zoxide python3-pip