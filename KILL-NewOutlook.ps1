# Define registry key paths
$registryPathHKCU = 'HKCU:\Software\Microsoft\Office\16.0\Outlook\Options\General';
$registryPathHKLM = 'HKLM:\Software\Policies\Microsoft\Office\16.0\Outlook\Options\General';
$registryPathPreinstall = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32';
$registryPathMailCalendarDeprecation = 'HKLM:\Software\Policies\Microsoft\Windows\System';

# Define the registry value name and data
$valueNameHideToggle = 'HideNewOutlookToggle';
$valueData = 1;
$valueNameBlockPreinstall = 'NewOutlookDisabled';
$valueNameMailCalendar = 'DisableNewOutlookInstall';

# Function to set the registry value
function Set-RegistryValue {
    param (
        [string]$Path,
        [string]$Name,
        [int]$Data
    )

    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null;
    }

    Set-ItemProperty -Path $Path -Name $Name -Value $Data -Force;
    Write-Host "Set registry value $Name at $Path to $Data";
}

# Remove provisioned app packages
function Remove-NewOutlookAppPackages {
    $packages = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like '*Outlook*' -or $_.DisplayName -like '*Mail*' -or $_.DisplayName -like '*Calendar*'};
    foreach ($package in $packages) {
        Write-Host "Removing provisioned package: $($package.DisplayName)";
        Remove-AppxProvisionedPackage -Online -PackageName $package.PackageName;
    }

    $userPackages = Get-AppxPackage -AllUsers | Where-Object {$_.Name -like '*Outlook*' -or $_.Name -like '*Mail*' -or $_.Name -like '*Calendar*'};
    foreach ($userPackage in $userPackages) {
        Write-Host "Removing user package: $($userPackage.Name)";
        Remove-AppxPackage -Package $userPackage.PackageFullName -AllUsers;
    }
}

# Set the registry value in HKCU (Current User)
Set-RegistryValue -Path $registryPathHKCU -Name $valueNameHideToggle -Data $valueData;

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Host "This script must be run as Administrator to modify HKLM. Exiting.";
    exit;
}

# Set the registry value in HKLM (Local Machine) for hiding the toggle
Set-RegistryValue -Path $registryPathHKLM -Name $valueNameHideToggle -Data $valueData;

# Block new Outlook preinstall on Windows
Set-RegistryValue -Path $registryPathPreinstall -Name $valueNameBlockPreinstall -Data $valueData;

# Block new Outlook installation as part of Mail and Calendar deprecation
Set-RegistryValue -Path $registryPathMailCalendarDeprecation -Name $valueNameMailCalendar -Data $valueData;

# Remove New Outlook app packages
Remove-NewOutlookAppPackages;

Write-Host "Successfully disabled the New Outlook toggle, blocked its preinstallation and installation, and removed related app packages.";
