$dest = "$HOME\.config\opencode";
$target = "$PSScriptRoot\opencode\.config\opencode"

New-Item -ItemType SymbolicLink -Force -Path "$dest\opencode.json" -Target "$target\opencode.json";
New-Item -ItemType SymbolicLink -Force -Path "$dest\tui.json" -Target "$target\tui.json";
New-Item -ItemType SymbolicLink -Force -Path "$dest\cli.json" -Target "$target\cli.json";
