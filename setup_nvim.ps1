$files = Get-ChildItem -Path $PSScriptRoot\nvim -Recurse -Filter "*.lua"

$config = "$HOME\.config\nvim";
if ($IsWindows) {
    $config = "$env:LOCALAPPDATA\nvim"
}

New-Item -ItemType Junction -Force -Path $config -Target $PSScriptRoot\nvim\.config\nvim;

# New-Item -ItemType SymbolicLink -Force -Path $config/lazy-lock.json -Target $PSScriptRoot\nvim\.config\nvim\lazy-lock.json

New-Item -ItemType SymbolicLink -Force -Path $HOME/.ideavimrc -Target $PSScriptRoot\nvim\.config\nvim\.ideavimrc
New-Item -ItemType SymbolicLink -Force -Path $HOME/.vsvimrc -Target $PSScriptRoot\nvim\.config\nvim\.vsvimrc
