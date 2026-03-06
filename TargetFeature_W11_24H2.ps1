<#-------------------------------------------------------#>
<#    Change Target Feature Update to Winodws 11 24H2    #>
<#-------------------------------------------------------#>

$RegistryPath1 =  'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'

<# Output Current Properties #>
Get-ItemProperty -Path $RegistryPath1

Start-Sleep -Seconds 2

Set-ItemProperty -Path $RegistryPath1 -Name 'ProductVersion' -Value 'Windows 11' -Type "String"

Set-ItemProperty -Path $RegistryPath1 -Name 'TargetReleaseVersion' -Value '00000001' -Type "DWord"

Set-ItemProperty -Path $RegistryPath1 -Name 'TargetReleaseVersionInfo' -Value '24H2' -Type "String"

Start-Sleep -Seconds 2

<# Output Updated Properties. Did anything change? If yes, Good to go! #>
Get-ItemProperty -Path $RegistryPath1

Start-Sleep -Seconds 2

exit

