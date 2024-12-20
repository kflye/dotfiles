$windowsTerminalSettingsPath = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json";
$windowsTerminalPreviewSettingsPath = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json";
$scoopInstall = "$HOME\scoop\apps\windows-terminal\current\settings\settings.json"
$target = "$PSScriptRoot\settings.json"

New-Item -ItemType SymbolicLink -Force -Path $windowsTerminalSettingsPath -Target $target;

New-Item -ItemType SymbolicLink -Force -Path $windowsTerminalPreviewSettingsPath -Target $target;

New-Item -ItemType SymbolicLink -Force -Path $scoopInstall -Target $target;