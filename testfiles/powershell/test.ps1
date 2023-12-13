if ($IsMacOS)
{
    $env:PATH += ":/usr/local/bin"
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(#{HOMEBREW_PREFIX}/bin/brew shellenv) | Invoke-Expression'
} elseif ($IsWindows)
{
    $env:PATH += ";$env:APPDATA\local\bin"
    $env:HOME = "$env:userprofile"
    $env:SHELL = "C:\Program Files\PowerShell\7\pwsh.exe"
} elseif ($IsLinux)
{
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(#{HOMEBREW_PREFIX}/bin/brew shellenv) | Invoke-Expression'
}

Import-Module Terminal-Icons
Import-Module PSfzf
Import-Module posh-git

$env:POSH_GIT_ENABLED = $true
#$GitPromptSettings.EnableFileStatus = $false # when oh-my-posh uses posh-git

function Invoke-Starship-PreCommand
{
    $f = (Split-Path -Leaf $pwd)
    $host.ui.Write("`e]0; $f `a")
}

Invoke-Expression (&starship init powershell)
