# winget install --id=Docker.DockerDesktop -e  ; 

winget install --id=Git.Git -e  ;
winget install --id=Microsoft.VisualStudioCode -e  ; 


winget install --id=Microsoft.PowerToys -e  ; 
winget install --id=Obsidian.Obsidian -e  ; 
winget install --id=Bitwarden.Bitwarden -e ;

# winget install --id=SamHocevar.WinCompose -e ;
winget install --id=Spotify.Spotify -e  ; 
winget install --id=7zip.7zip -e  ;
winget install --id=SamHocevar.WinCompose  -e

winget install --id=Rustlang.Rustup  -e
winget install --id=GoLang.Go  -e

### WORK ###

# winget install -e --id gsass1.NTop
# winget install -e --id JesseDuffield.lazygit
# winget install -e --id Obsidian.Obsidian
# winget install -e --id Postman.Postman
# winget install -e --id JetBrains.Toolbox

# winget install -e --id GnuWin32.Make # ERROR
# winget install -e --id CoreyButler.NVMforWindows

# winget install -e --id Starship.Starship
# winget install -e --id ajeetdsouza.zoxide
# winget install -e --id sharkdp.bat
# winget install -e --id sharkdp.fd
# winget install -e --id BurntSushi.ripgrep.GNU
# winget install -e --id junegunn.fzf
# winget install -e --id jftuga.less

# winget install -e --id Neovim.Neovim

# winget install -e --id Helm.Helm
# winget install -e --id Insomnia.Insomnia

# winget install -e --id dandavison.delta
# winget install -e --id EclipseAdoptium.Temurin.17.JDK
# winget install -e --id EclipseAdoptium.Temurin.21.JDK

### WORK ###

# https://github.com/ryanoasis/nerd-fonts/releases/latest/
# https://github.com/ryanoasis/nerd-fonts/discussions/1103
# Have installed all 'JetBrainsMonoNerdFont-' variants
# Without mono have larger icons, Still mono spaced? Only icons larger?

# https://github.com/sainnhe/gruvbox-material/wiki/Related-Projects


# scoop bucket add nerd-fonts
# scoop install nerd-fonts/JetBrainsMono-NF

# For neovim nigthly
scoop bucket add main
scoop bucket add extras
scoop bucket add versions

# scoop install vcredist2022
# winget install --id=Microsoft.VCRedist.2015+.x64  -e

scoop install main/7zip # open 7-zip as admin and add context menu
scoop install main/ntop
scoop install extras/lazygit
scoop install extras/obsidian
scoop install extras/postman
scoop install extras/insomnia
scoop install extras/jetbrains-toolbox
scoop install extras/spotify
scoop install extras/wincompose
scoop install extras/powertoys
scoop install extras/bitwarden


scoop install main/git
scoop install main/make
scoop install main/gcc
scoop install main/nvm
scoop install main/go
scoop install main/rustup
scoop install main/helm


scoop install main/starship
scoop install main/zoxide
scoop install main/bat
scoop install main/fd
scoop install main/fzf
scoop install main/ripgrep
scoop install main/delta
scoop install main/less


scoop install main/neovim
scoop install main/dark


scoop install java/temurin17-jdk
scoop install java/temurin21-jdk