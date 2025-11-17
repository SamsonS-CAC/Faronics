<#
.SYNOPSIS
    Uninstalls all versions of Cisco Webex (Meetings, Teams, Webex App)
    from a Windows machine by scanning uninstall registry keys and
    calling msiexec for every matching product.
#>

Write-Host "Searching for Cisco Webex installations..." -ForegroundColor Cyan

# Registry paths to check (both x64 and x86)
$paths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$webexApps = foreach ($path in $paths) {
    Get-ItemProperty $path -ErrorAction SilentlyContinue |
        Where-Object {
            $_.DisplayName -match "Webex"
        }
}

if (-not $webexApps) {
    Write-Host "No Cisco Webex products found." -ForegroundColor Yellow
    return
}

Write-Host "Found the following Cisco Webex installations:" -ForegroundColor Green
$webexApps | Select DisplayName, DisplayVersion, Publisher, UninstallString | Format-Table -AutoSize

foreach ($app in $webexApps) {
    Write-Host "Removing: $($app.DisplayName) ..." -ForegroundColor Cyan

    $uninstall = $app.UninstallString

    if ($uninstall -match "msiexec") {
        # Normalize the command for silent uninstall
        $normalized = $uninstall `
            -replace "/I", "/X" `
            -replace "/i", "/X"

        # Append silent uninstall flags if missing
        if ($normalized -notmatch "/qn") {
            $normalized += " /qn /norestart"
        }

        Write-Host "Running: $normalized" -ForegroundColor Gray
        Start-Process "cmd.exe" -ArgumentList "/c $normalized" -Wait
    }
    else {
        # EXE or other uninstaller
        Write-Host "Running external uninstaller..." -ForegroundColor Gray
        Start-Process "cmd.exe" -ArgumentList "/c `"$uninstall`" /silent /norestart" -Wait -ErrorAction SilentlyContinue
    }
}

Write-Host "`nAll detected Cisco Webex products have been removed." -ForegroundColor Green
