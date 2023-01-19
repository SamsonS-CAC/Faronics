Get-Printer | Where-Object { $_.Name -notmatch "PDF" } | Remove-Printer
Start-Sleep -Seconds 5
Add-PrinterPort -Name "10.70.10.14" -PrinterHostAddress "10.70.10.14"
Start-Sleep -Seconds 5
Add-Printer -DriverName "HP Universal Printing PCL 6" -Name "HP PRINTER STC-C117 Learning Center" -PortName "10.70.10.14"
