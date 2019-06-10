# Author: Justin Trusty (sourced from multiple gists and blogs)
# https://github.com/Microsoft/windows-dev-box-setup-scripts
# https://github.com/felixrieseberg/windows-development-environment
# https://gist.github.com/NickCraver/7ebf9efbfd0c3eab72e9

# Test-Admin is not available yet, so use...
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-noprofile -NoExit -file `"$PSCommandPath`"" -Verb RunAs
    Exit
}

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

Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/jtrusty/win10-setup/master/boxstarter.ps1 -DisableReboots
