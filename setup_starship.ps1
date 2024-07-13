$dest = "$env:HOME\.config\starship.toml";
$target = "$PSScriptRoot\starship.toml"

New-Item -ItemType SymbolicLink -Force -Path $dest -Target $target;