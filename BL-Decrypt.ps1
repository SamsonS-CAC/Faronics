# Get all drives with BitLocker enabled
$bitlockerDrives = Get-BitLockerVolume | Where-Object {$_.ProtectionStatus -eq 'On'}

# Loop through each drive and disable BitLocker
foreach ($drive in $bitlockerDrives) {
    Disable-BitLocker -MountPoint $drive.MountPoint
    Write-Output "Decryption started for drive: $($drive.MountPoint)"
}
