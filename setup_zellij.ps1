$dest = "$HOME\AppData\Roaming\Zellij\config\config.kdl";
$target = "$PSScriptRoot\zellij\.config\zellij\config.kdl"

New-Item -ItemType SymbolicLink -Force -Path $dest -Target $target;
