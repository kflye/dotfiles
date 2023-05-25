{ config, pkgs, ... }:

{
  home.username = "flye";
  home.homeDirectory = "/home/flye";

  home.packages = with pkgs; [
    neovim
    git
    gcc
    zig
    zip
    unzip
    gnumake
    nodejs

    nerdfonts
    kanata

    vscode
    brave
    starship
    wezterm

    rustup
    fish
  ];

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
}
