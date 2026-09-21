$path = "$PSScriptRoot"

Set-Content -Path $PROFILE -Encoding utf8 -Value @'
$dotfileProfile = Join-Path $HOME '.dotfiles\powershell\Microsoft.PowerShell_profile.ps1'

if (Test-Path $dotfileProfile) {
    . $dotfileProfile
}
else {
    Write-Warning "Dotfile profile not found: $dotfileProfile"
}
'@

function Install($moduleName) {
    Install-Module $moduleName  -Confirm:$False -Force -Scope CurrentUser;
}


# Install("PSfzf");
# Install("Terminal-Icons");
# Install("posh-git")

# Install("posh-sshell");
# Install("ZLocation");
