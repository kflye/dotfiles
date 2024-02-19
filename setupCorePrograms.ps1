choco install firacodenf nerd-fonts-jetbrainsmono `
  zig `
  mingw `
  make `
  -y

# zig -> c++ compiler for nvim-treesitter parsers

winget install --id=Git.Git -e  ;
winget install --id=jftuga.less -e ;
winget install --id=dandavison.delta -e ;
winget install --id=Microsoft.VisualStudioCode -e  ; 
winget install --id=Docker.DockerDesktop -e  ; 
winget install --id=JetBrains.Toolbox -e  ; 
winget install --id=CoreyButler.NVMforWindows -e  ; # nvm for nodejs, 'nvm install 18.14.2 -> nvm use 18.14.2
winget install --id=Postman.Postman -e  ; 

winget install --id=ajeetdsouza.zoxide -e  ; 
winget install --id=Starship.Starship -e  ;

winget install --id=Microsoft.PowerToys -e  ; 
winget install --id=Obsidian.Obsidian -e  ; 
winget install --id=Bitwarden.Bitwarden -e ;

winget install --id=SamHocevar.WinCompose -e ;
winget install --id=QMK.QMKToolbox -e  ; 
winget install --id=Spotify.Spotify -e  ; 
winget install --id=7zip.7zip -e  ;



# https://github.com/ryanoasis/nerd-fonts/releases/latest/
# https://github.com/ryanoasis/nerd-fonts/discussions/1103
# Have installed all 'JetBrainsMonoNerdFont-' variants
# Without mono have larger icons, Still mono spaced? Only icons larger?

# https://github.com/sainnhe/gruvbox-material/wiki/Related-Projects

## scoop
winget install --id=Neovim.Neovim -e  ; 
winget install --id=junegunn.fzf -e  ; 
winget install --id=sharkdp.fd -e  ; 
winget install --id=BurntSushi.ripgrep.GNU -e  ; 
winget install --id=sharkdp.bat -e  ; 
winget install --id=gsass1.NTop -e ;

scoop bucket add nerd-fonts
scoop install nerd-fonts/JetBrainsMono-NF

# For neovim nigthly
scoop bucket add main
scoop bucket add extras
scoop bucket add versions

scoop install vcredist2022
scoop install versions/neovim-nightly
scoop install main/neovim
scoop install main/fzf
scoop install main/fd
scoop install main/ripgrep
scoop install main/make
scoop install main/gcc
scoop install main/bat
scoop install main/ntop
scoop install main/nodejs