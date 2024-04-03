$files = Get-ChildItem -Path $PSScriptRoot -Recurse -Filter "*.lua"

$config = "$HOME\.config\nvim";
if ($IsWindows) {
    $config = "$env:LOCALAPPDATA\nvim"
}

New-Item -ItemType Junction -Force -Path $config -Target $PSScriptRoot;

New-Item -ItemType SymbolicLink -Force -Path $config/lazy-lock.json -Target $PSScriptRoot\lazy-lock.json

New-Item -ItemType SymbolicLink -Force -Path $HOME/.ideavimrc -Target $PSScriptRoot\.ideavimrc
New-Item -ItemType SymbolicLink -Force -Path $HOME/.vsvimrc -Target $PSScriptRoot\.vsvimrc
