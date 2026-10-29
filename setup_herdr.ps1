$dest = "$env:APPDATA\herdr\config.toml";
$target = "$PSScriptRoot\herdr\.config\herdr\config.toml"

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null

if ((Test-Path -LiteralPath $dest) -and
    (Get-Item -LiteralPath $dest -Force).LinkType -ne "SymbolicLink") {
    throw "Refusing to replace an existing Herdr config: $dest"
}

New-Item -ItemType SymbolicLink -Force -Path $dest -Target $target;
