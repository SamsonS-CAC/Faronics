Remove-AppxProvisionedPackage -AllUsers -Online -PackageName (Get-AppxPackage Microsoft.OutlookForWindows).PackageFullName
Remove-AppxPackage -AllUsers -Package (Get-AppxPackage Microsoft.OutlookForWindows).PackageFullName

Remove-AppxProvisionedPackage -AllUsers -Online -PackageName (Get-AppxPackage microsoft.windowscommunicationsapps).PackageFullName
Remove-AppxPackage -AllUsers -Package (Get-AppxPackage microsoft.windowscommunicationsapps).PackageFullName
