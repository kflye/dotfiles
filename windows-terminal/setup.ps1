$windowsTerminalSettingsPath = "$env:HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json";
$windowsTerminalSettingsPath = "$env:HOME\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json";
$scoopInstall = "$env:HOME\scoop\apps\windows-terminal\current\settings\settings.json"
$target = "$PSScriptRoot\settings.json"

New-Item -ItemType SymbolicLink -Force -Path $windowsTerminalSettingsPath -Target $target;

New-Item -ItemType SymbolicLink -Force -Path $windowsTerminalSettingsPath -Target $target;

New-Item -ItemType SymbolicLink -Force -Path $scoopInstall -Target $target;