####################################################################################
#### -------------------------------------------------------------------------- ####
#### Auto Delete User Profiles older than 180 days via GP -- Updated 09/03/2024 ####
#### -------------------------------------------------------------------------- ####
####################################################################################

$RegistryPath1 =  'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System'
New-Item -Path $RegistryPath1

Set-ItemProperty -Path $RegistryPath1 -Name 'CleanupProfiles' -Value '180' -Type "DWord"

Start-Sleep -Seconds 2
