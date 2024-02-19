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

# Install-Module VSSetup -Scope CurrentUser
# Install-Module Pscx -Scope CurrentUser (-AllowClobber)
# Import-VisualStudioVars -- Make visual studi variables available in session (cmake etc)

Import-Module Terminal-Icons
Import-Module PSfzf
Import-Module posh-git

$env:POSH_GIT_ENABLED = $true
#$GitPromptSettings.EnableFileStatus = $false # when oh-my-posh uses posh-git
$env:BAT_THEME = "TwoDark"

function Invoke-Starship-PreCommand
{
    $f = (Split-Path -Leaf $pwd)
    $host.ui.Write("`e]0; $f `a")
}

Invoke-Expression (&starship init powershell)

Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6)
        { 'prompt' 
        } else
        { 'pwd' 
        }
    (zoxide init --hook $hook powershell | Out-String)
    })

############################################ fzf
# fzf
Import-Module PSReadLine
# press the directory separator (\) character to complete the current selection and start tab completion for the next part of the container path
Set-PSReadLineKeyHandler -Chord Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward

Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true

Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -Colors @{ InlinePrediction = '#000055' }
Set-PSReadLineOption -HistorySavePath "$HOME/.powershell/history"

# ctrl+r - history search
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r' 
Set-PsFzfOption -TabExpansion
Set-PsFzfOption -EnableAliasFuzzyZLocation

$env:FZF_DEFAULT_COMMAND = 'fd --type f --color=never --hidden'
$env:FZF_DEFAULT_OPTS = '--no-height --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'

# ctrl+t - find
$env:FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND"
$env:FZF_CTRL_T_OPTS = "--preview 'bat --color=always --line-range :50 {}'"

# alt+c - change directory
$env:FZF_ALT_C_COMMAND = 'fd --type d . --color=never --hidden'

# alt+a - select one or more command line arguments from history

############################################

# Alias
Set-Alias vim nvim
if ($IsWindows)
{
    Set-Alias htop ntop
}
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'

function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function cat($name)
{
    Get-Content $name
}

function vs
{
    param (
        [PSDefaultValue(Help = 'Current directory')]
        [string[]] $SearchPath = '.',
        [PSDefaultValue(Help = 'Current depth')]
        $Depth = 1, 
        [PSDefaultValue(Help = 'Max depth')]
        $Max = 5
    )
    $item = Get-ChildItem "*.sln" -Depth $Depth -Path $SearchPath | Select-Object -First 1
    if ($item)
    {
        Invoke-Expression "rider $item"
        return
    }
    if ($Depth -ge $Max)
    {
        Write-Host "not found at depth $Depth"
        return
    }

    $Depth = $Depth + 1
    return vs -depth $Depth -Max $Max
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
    Import-Module "$ChocolateyProfile"
}

function tcp_prog
{
    param (
        [PSDefaultValue(Help = 'TCP Port to lookup')]
        $Port
    )

    Get-Process -Id (Get-NetTCPConnection -LocalPort $Port).OwningProcess
}

$env:LOCAL_NUGET = "$env:HOME\.nuget_local"

function nuget_push
{
    $pkgs = Get-ChildItem "*.*nupkg" -Recurse
    foreach ($pkg in $pkgs)
    {
        Write-Host "pushing $pkg"
        Invoke-Expression "dotnet nuget push $pkg -s $env:LOCAL_NUGET"
    }
}

function start_records
{
    Invoke-Expression "dotnet run --project='$env:USERPROFILE\repos\services.report\src\Services.Reports.Api' --launch-profile=Local"
}
