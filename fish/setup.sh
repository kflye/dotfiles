#!/usr/bin/env fish

wget https://gitlab.com/kyb/fish_ssh_agent/raw/master/functions/fish_ssh_agent.fish -P ~/.config/fish/functions/

# run these in a fish shell
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Theme
fisher install jomik/fish-gruvbox

# using build in function for setting up fzf keybindings (missing tab completion?)
# fisher install jethrokuan/fzf