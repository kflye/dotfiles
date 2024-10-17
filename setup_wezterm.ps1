$dest = "$env:HOME\.wezterm.lua";
$target = "$PSScriptRoot\wezterm\.wezterm.lua"

New-Item -ItemType SymbolicLink -Force -Path $dest -Target $target;