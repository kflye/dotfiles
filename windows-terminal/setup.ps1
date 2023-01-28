$windowsTerminalSettingsPath = "$env:HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json";
$target = "$PSScriptRoot\settings.json"

New-Item -ItemType SymbolicLink -Force -Path $windowsTerminalSettingsPath -Target $target;