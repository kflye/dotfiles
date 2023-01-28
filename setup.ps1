$setups = Get-ChildItem -Directory -Path $PSScriptRoot | Get-ChildItem -Filter setup.ps1

# -Filter setup.ps1
foreach ($item in $setups) {
    Write-Host "Setup $($item.Directory.Name)\$($item.Name)"
    & $item
}
