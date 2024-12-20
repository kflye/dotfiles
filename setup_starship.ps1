$dest = "$HOME\.config\starship.toml";
$target = "$PSScriptRoot\starship\.config\starship.toml"

New-Item -ItemType SymbolicLink -Force -Path $dest -Target $target;