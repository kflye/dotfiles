
## Install vim
if (!(Test-Path -PathType Container $HOME/.vim/undo-dir)) {
	New-Item -ItemType Directory -Path $HOME/.vim/undo-dir
}
#New-Item -ItemType SymbolicLink -Force -Path $HOME/.vimrc -Target $PSScriptRoot\.vimrc
New-Item -ItemType SymbolicLink -Force -Path $HOME/.ideavimrc -Target $PSScriptRoot\.ideavimrc
if($IsWindows) {
	#New-Item -ItemType SymbolicLink -Force -Path $env:LOCALAPPDATA/nvim/init.vim -Target $PSScriptRoot\nvim\init.vim
}
else {
	#New-Item -ItemType SymbolicLink -Force -Path ~/.config/nvim/init.vim -Target $PSScriptRoot\nvim\init.vim
}


