# Define Paths
$Win11SetupPath = "\\centralaz.cac\shares\Tech\ITSA\23H2-W11-UPG\W11_ISO"  # Update this with the actual network path of the extracted win11 .iso files
#This above share is the only edit you will need to make to this script. Below defines where the setupExe is.
$SetupExe = "$Win11SetupPath\setup.exe"

#Check for Logs Folder and create it if it doesn't exist
$LogsFolder = "C:\ITS\Logs"

if (-not (Test-Path $LogsFolder)) {
    New-Item -ItemType Directory -Path $LogsFolder > $null
}

#Define Log File path
$LogPath = "C:\ITS\Logs\CAC_Win11Upgrade.log"

# ULFC = Upgrade Log File Copy. Now we will specify the variables used to copy and rename the resulting log file to a network share
$ULFC_hostname = $env:COMPUTERNAME
$ULFC_destPath = "\\centralaz.cac\shares\Tech\ITSA\23H2-W11-UPG\Logs"     # Remote file share path; create if it doesn't exist

if (-not (Test-Path $ULFC_destPath)) {
    New-Item -ItemType Directory -Path $ULFC_destPath > $null
}

# Get the OS version
$osVersion = (Get-CimInstance Win32_OperatingSystem).Version
$buildNumber = [int]($osVersion.Split('.')[2])

# Windows 11 starts at build number 22000
if ($buildNumber -ge 22000) {
    # Windows 11 is installed — exit the script
    Write-Output "Checking OS version... Windows 11 is already installed. Exiting script." | Out-File -Append $LogPath

    # ULFC - Create destination file name with hostname and timestamp. Copy it to network share.
    $ULFC_timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $ULFC_destFile = "Win11UpgLog_${ULFC_hostname}_$ULFC_timestamp.log"
    $ULFC_destFullPath = Join-Path -Path $ULFC_destPath -ChildPath $ULFC_destFile
    Copy-Item -Path $LogPath -Destination $ULFC_destFullPath > $null
    
    Exit 0
}

# If no Windows 11 installed, Continue with the rest of your script here
Write-Output "Checking OS version... Windows 11 is not installed. Proceeding..." | Out-File -Append $LogPath

# Ensure the Setup.exe exists before proceeding
if (!(Test-Path $SetupExe)) {
    Write-Output "ERROR: setup.exe not found at $SetupExe" | Out-File -Append $LogPath

    # ULFC - Create destination file name with hostname and timestamp. Copy it to network share.
    $ULFC_timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $ULFC_destFile = "Win11UpgLog_${ULFC_hostname}_$ULFC_timestamp.log"
    $ULFC_destFullPath = Join-Path -Path $ULFC_destPath -ChildPath $ULFC_destFile
    Copy-Item -Path $LogPath -Destination $ULFC_destFullPath > $null
   
    Exit 1
}

# Check if upgrade is already in progress
$SetupProcess = Get-Process -Name "setup" -ErrorAction SilentlyContinue
if ($SetupProcess) {
    Write-Output "Windows 11 upgrade is already in progress. Exiting script." | Out-File -Append $LogPath

    # ULFC - Create destination file name with hostname and timestamp. Copy it to network share.
    $ULFC_timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $ULFC_destFile = "Win11UpgLog_${ULFC_hostname}_$ULFC_timestamp.log"
    $ULFC_destFullPath = Join-Path -Path $ULFC_destPath -ChildPath $ULFC_destFile
    Copy-Item -Path $LogPath -Destination $ULFC_destFullPath > $null
    
    Exit 0
}

Write-Output "Starting Windows 11 Upgrade..." | Out-File -Append $LogPath

# Run Setup.exe with silent upgrade switches
Start-Process -FilePath $SetupExe -ArgumentList "/auto upgrade /quiet /noreboot /dynamicupdate disable /eula accept /compat ignorewarning /migratedrivers all /showoobe none" -NoNewWindow -Wait

# Monitor setup.exe to ensure it's not hung
$TimeoutMinutes = 180  # Set a timeout to prevent infinite hanging
$StartTime = Get-Date

while ($true) {
    $SetupProcess = Get-Process -Name "setup" -ErrorAction SilentlyContinue
    if (!$SetupProcess) {
        Write-Output "Windows 11 upgrade process has completed or exited." | Out-File -Append $LogPath
        Break
    }

    # Check if setup is stuck for too long
    $ElapsedMinutes = (New-TimeSpan -Start $StartTime -End (Get-Date)).TotalMinutes
    if ($ElapsedMinutes -ge $TimeoutMinutes) {
        Write-Output "WARNING: Windows 11 upgrade process appears to be hung. Attempting to restart setup.exe..." | Out-File -Append $LogPath
        Stop-Process -Name "setup" -Force
        Start-Sleep -Seconds 10
        Start-Process -FilePath $SetupExe -ArgumentList "/auto upgrade /quiet /noreboot /dynamicupdate disable /eula accept /compat ignorewarning /migratedrivers all /showoobe none" -NoNewWindow -Wait
        $StartTime = Get-Date  # Reset timer
    }

    Start-Sleep -Seconds 60  # Check every minute
}

# Ensure Upgrade Was Successful
$OSVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
if ($OSVersion -ge 22000) {
    Write-Output "Windows 11 upgrade was successful. System must reboot to complete the process." | Out-File -Append $LogPath
    
    # Remove installation files (Disabled because source is network share)
    #Disabled# Remove-Item -Path $Win11SetupPath -Recurse -Force -ErrorAction SilentlyContinue
    #Disabled# Write-Output "Installation files deleted successfully." | Out-File -Append $LogPath

    # ULFC - Create destination file name with hostname and timestamp. Copy it to network share.
    $ULFC_timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $ULFC_destFile = "Win11UpgLog_${ULFC_hostname}_$ULFC_timestamp.log"
    $ULFC_destFullPath = Join-Path -Path $ULFC_destPath -ChildPath $ULFC_destFile
    Copy-Item -Path $LogPath -Destination $ULFC_destFullPath > $null
    
    # Reboot system
    Write-Output "Rebooting the system in 600 seconds..." | Out-File -Append $LogPath
    Start-Sleep -Seconds 600
    Restart-Computer -Force
} else {
    Write-Output "ERROR: Windows 11 upgrade failed. Please check logs." | Out-File -Append $LogPath

    # ULFC - Create destination file name with hostname and timestamp. Copy it to network share.
    $ULFC_timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $ULFC_destFile = "Win11UpgLog_${ULFC_hostname}_$ULFC_timestamp.log"
    $ULFC_destFullPath = Join-Path -Path $ULFC_destPath -ChildPath $ULFC_destFile
    Copy-Item -Path $LogPath -Destination $ULFC_destFullPath > $null

    Exit 1
}
