Get-Printer | Where-Object { $_.Name -notmatch "PDF" } | Remove-Printer
Start-Sleep -Seconds 5
Add-PrinterPort -Name "10.60.10.18" -PrinterHostAddress "10.60.10.18"
Start-Sleep -Seconds 5
Add-Printer -DriverName "HP Universal Printing PCL 6" -Name "HP PRINTER MAR-B101 Library" -PortName "10.60.10.18"
