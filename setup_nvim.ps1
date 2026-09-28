$files = Get-ChildItem -Path $PSScriptRoot\nvim -Recurse -Filter "*.lua"

$config = "$HOME\.config\nvim";
if ($IsWindows) {
    $config = "$env:LOCALAPPDATA\nvim"
}

New-Item -ItemType Junction -Force -Path $config -Target $PSScriptRoot\nvim\.config\nvim;

New-Item -ItemType SymbolicLink -Force -Path $HOME/.ideavimrc -Target $PSScriptRoot\ideavim\.ideavimrc