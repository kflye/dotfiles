starship init fish | source
zoxide init fish | source

fish_add_path -a $HOME/.cargo/bin
fish_add_path -a $HOME/.local/bin

fish_ssh_agent

# Enable fzf key bindings
fzf_key_bindings

# fish_config theme save "tokyonight_storm"
theme_gruvbox dark medium

if test -e  ~/.ssh/id_rsa
    echo "id_rsa exists"
    set cmd keychain --eval --agents ssh ~/.ssh/id_rsa
end

if test -e  ~/.ssh/id_ed25519
    echo "id_ed25519 exists"
    set cmd keychain --eval --agents ssh ~/.ssh/id_ed25519
end

eval $cmd
