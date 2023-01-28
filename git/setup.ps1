$path = "$PSScriptRoot"

$localGitConfig = "$HOME/.gitconfig.local"

if (-not (Test-Path -Path $localGitConfig -PathType Leaf)) {
    Copy-Item "$path\.gitconfig.local" $localGitConfig
}


New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitconfig -Target $path\.gitconfig;
New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitignore -Target $path\.gitignore
New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitattributes -Target $path\.gitattributes


# $IsMacOS
# $IsLinux
# $IsWindows
if ($IsWindows)
{
    #SSH Agent
    Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*';
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0;
    Get-Service -Name ssh-agent | Set-Service -StartupType Automatic;
}
