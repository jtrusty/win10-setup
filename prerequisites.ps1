# Author: Justin Trusty (sourced from multiple gists and blogs)
# https://github.com/Microsoft/windows-dev-box-setup-scripts
# https://github.com/felixrieseberg/windows-development-environment
# https://gist.github.com/NickCraver/7ebf9efbfd0c3eab72e9

# Test-Admin is not available yet, so use...
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-noprofile -NoExit -file `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Boxstarter options
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

# From a Administrator PowerShell, if Get-ExecutionPolicy returns Restricted, run:
if ((Get-ExecutionPolicy) -eq "Restricted") {
    Set-ExecutionPolicy Unrestricted -Force
}

#Set ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
Enable-RemoteDesktop
Disable-InternetExplorerESC
Set-StartScreenOptions -EnableBootToDesktop

# Update Windows and reboot if necessary
Install-WindowsUpdate -AcceptEula
if (Test-PendingReboot) { Invoke-Reboot }

### Chocolatey Installs ###
write-host "Installing/Upgrading Chocolatey" -ForegroundColor "Yellow"

# Install Chocolatey: https://chocolatey.org/install
if (!(Test-Path 'C:\ProgramData\chocolatey\bin\choco.exe')) {
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}
else {
  choco upgrade chocolatey
}

RefreshEnv

# Enable Chocolatey Autoconfirm
choco feature enable -n allowGlobalConfirmation

write-host "Installing/Upgrading Boxstarter" -ForegroundColor "Yellow"

# Install Boxstarter: http://boxstarter.org/InstallBoxstarter
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force

Install-BoxstarterPackage -PackgeName https://raw.githubusercontent.com/jtrusty/win10-setup/master/win10-setup.ps1 -DisableReboots
