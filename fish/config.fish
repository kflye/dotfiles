starship init fish | source
zoxide init fish | source

fish_add_path -a $HOME/.cargo/bin
fish_add_path -a $HOME/.local/bin
fish_add_path -a $HOME/local/llvm17-release/bin
fish_add_path -a $HOME/.tmux/plugins/tmuxifier/bin

fish_ssh_agent

# Enable fzf key bindings
set -u FZF_DEFAULT_COMMAND "fd --type f --color=never --hidden"
set -U FZF_CTRL_T_COMMAND "fd --type f --color=never --hidden"
set -U FZF_CTRL_T_OPTS "--preview 'bat --color=always --line-range :50 {}'"
set -U FZF_ALT_C_COMMAND "fd --type d --color=never --hidden"
fzf_key_bindings

fish_config theme choose "kanagawa"
# fish_config theme choose "tokyonight_storm"
# theme_gruvbox dark medium

set -l SSH_KEYS ~/.ssh/id_rsa ~/.ssh/id_ed25519
for FILE in $SSH_KEYS
    if test -e $FILE
        set cmd keychain --eval --agents ssh $FILE
    end
end 

set -u XDG_CONFIG_HOME "$HOME/.config"

eval (tmuxifier init - fish)
eval $cmd
