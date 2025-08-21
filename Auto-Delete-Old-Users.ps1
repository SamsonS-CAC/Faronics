###################################################################################
#### ------------------------------------------------------------------------- ####
####   Auto Delete Old User Profiles via Group Policy -- Updated 08/27/2024    ####
#### ------------------------------------------------------------------------- ####
###################################################################################

$RegistryPath1 =  'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System'
New-Item -Path $RegistryPath1

Set-ItemProperty -Path $RegistryPath1 -Name 'CleanupProfiles' -Value '15' -Type "DWord"

Start-Sleep -Seconds 2
