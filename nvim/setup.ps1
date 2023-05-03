$files = Get-ChildItem -Path $PSScriptRoot -Recurse -Filter "*.lua"


$config = "$HOME\.config\nvim";
if ($IsWindows) {
    $config = "$env:LOCALAPPDATA\nvim"
}

$oldFiles = Get-ChildItem -Path $config -Recurse -Filter "*.lua" | Where-Object { $_.Attributes -match "ReparsePoint" }
foreach ($source in $oldFiles) {
    Remove-Item $source
}

foreach ($source in $files) {
    $rel = $source.FullName -replace "^$([regex]::Escape($PSScriptRoot))"
    $dest = "${config}${rel}"

    #Write-Host "dest: ${dest} - target ${source}"
    New-Item -ItemType SymbolicLink -Force -Path $dest -Target $source;
}
New-Item -ItemType SymbolicLink -Force -Path $config/lazy-lock.json -Target $PSScriptRoot\lazy-lock.json

New-Item -ItemType SymbolicLink -Force -Path $HOME/.ideavimrc -Target $PSScriptRoot\.ideavimrc
