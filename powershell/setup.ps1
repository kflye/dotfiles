$path = "$PSScriptRoot"

New-Item -ItemType SymbolicLink -Force -Path $profile -Target $path\Microsoft.PowerShell_profile.ps1;


function Install($moduleName) {
    Install-Module $moduleName  -Confirm:$False -Force -Scope CurrentUser;
}


# Install("posh-git")
# Install("PSfzf");
#Install("ZLocation");
#Install("posh-sshell");
# Install("Terminal-Icons");
