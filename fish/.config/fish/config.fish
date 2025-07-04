if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_ssh_agent
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source

    fish_config theme choose "kanagawa"
    # fish_config theme choose "tokyonight_storm"
    # theme_gruvbox dark medium

    # set -l SSH_KEYS ~/.ssh/id_rsa ~/.ssh/id_ed25519
    # for FILE in $SSH_KEYS
    #     if test -e $FILE
    #         set cmd keychain --eval --agents ssh $FILE
    #     end
    # end 
    # eval $cmd
    
    if test -e "/usr/sbin/wsl2-ssh-agent"
        eval "$(/usr/sbin/wsl2-ssh-agent)"
    end

    # clone and run install from https://github.com/junegunn/fzf 
    # fish_user_key_bindings

    # Enable fzf key bindings
    # set -u FZF_DEFAULT_COMMAND "fd --type f --color=never --hidden"
    # set -U FZF_CTRL_T_COMMAND "fd --type f --color=never --hidden"
    # set -U FZF_CTRL_T_OPTS "--preview 'bat --color=always --line-range :50 {}'"
    # set -U FZF_ALT_C_COMMAND "fd --type d --color=never --hidden"

    # opam configuration (keyboard generator)
    source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

    dbus-update-activation-environment --systemd DISPLAY
end

fish_add_path -a $HOME/.cargo/bin
fish_add_path -a $HOME/.local/bin
fish_add_path -a $HOME/.local/share/zig
fish_add_path -a $HOME/local/llvm17-release/bin
fish_add_path -a /usr/local/go/bin
fish_add_path -a /usr/share/go/bin
fish_add_path -a /usr/share/zig

set -gx VISUAL nvim
set -gx EDITOR "$VISUAL"

set -gx XDG_CONFIG_HOME "$HOME/.config"
set --universal nvm_default_version lts
