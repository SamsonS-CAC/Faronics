# Define Paths
$Win11SetupPath = "\\spcstuapps01\Software\ITSA\23H2-W11-UPG\W11_ISO"  # Update this with the actual network path of the extracted win11 .iso files
#This above share is the only edit you will need to make to this script
$LogPath = "C:\Windows\Temp\CAC_Win11Upgrade.log"
$SetupExe = "$Win11SetupPath\setup.exe"

# Get the OS version
$osVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
$buildNumber = int[2])

# Windows 11 starts at build number 22000
if ($buildNumber -ge 22000) {
    # Windows 11 is installed — exit the script
    Write-Output "Checking OS version... Windows 11 is already installed. Exiting script." | Out-File -Append $LogPath
    exit 0
}

# If no Windows 11 installed, Continue with the rest of your script here
Write-Output "Checking OS version... Windows 11 is not installed. Proceeding..." | Out-File -Append $LogPath

# Ensure the Setup.exe exists before proceeding
if (!(Test-Path $SetupExe)) {
    Write-Output "ERROR: setup.exe not found at $SetupExe" | Out-File -Append $LogPath
    Exit 1
}

# Check if upgrade is already in progress
$SetupProcess = Get-Process -Name "setup" -ErrorAction SilentlyContinue
if ($SetupProcess) {
    Write-Output "Windows 11 upgrade is already in progress. Exiting script." | Out-File -Append $LogPath
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
    Write-Output "Windows 11 upgrade was successful. Cleaning up installation files..." | Out-File -Append $LogPath
    
    # Remove installation files
    Remove-Item -Path $Win11SetupPath -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Installation files deleted successfully." | Out-File -Append $LogPath
    
    # Reboot system
    Write-Output "Rebooting the system in 30 seconds..." | Out-File -Append $LogPath
    Start-Sleep -Seconds 30
    Restart-Computer -Force
} else {
    Write-Output "ERROR: Windows 11 upgrade failed. Please check logs." | Out-File -Append $LogPath
    Exit 1
}
