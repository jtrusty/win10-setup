# Description: Boxstarter Script for Windows 10

#--- Rename the Computer ---
# Requires restart, or add the -Restart flag
$computername = "gaming-laptop"
if ($env:computername -ne $computername) {
	Rename-Computer -NewName $computername
}

# Begin running install & configuration scripts
Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"

$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri" -ForegroundColor "Yellow"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "system-configuration.ps1";
executeScript "file-explorer-settings.ps1";
executeScript "remove-builtin-apps.ps1";
executeScript "developer-tools.ps1";
executeScript "default-apps.ps1";
executeScript "misc-stuff.ps1";

write-host "Scripts installed" -ForegroundColor "Yellow"
Enable-UAC

write-host "Starting Windows Updates" -ForegroundColor "Yellow"
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula -GetUpdatesFromMS
