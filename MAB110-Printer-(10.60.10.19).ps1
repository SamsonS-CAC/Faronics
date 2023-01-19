Get-Printer | Where-Object { $_.Name -notmatch "PDF" } | Remove-Printer
Start-Sleep -Seconds 5
Add-PrinterPort -Name "10.60.10.19" -PrinterHostAddress "10.60.10.19"
Start-Sleep -Seconds 5
pnputil.exe /a "\\spcstuapps01\Software\Drivers\HP Universal Print Driver\pcl6-x64-7.0.1.24923\*.inf"
Start-Sleep -Seconds 5
Add-PrinterDriver -Name "HP Universal Printing PCL 6" -InfPath "C:\Windows\System32\DriverStore\FileRepository\hpcu255u.inf_amd64_883dd40f467c5d42\hpcu255u.inf"
Start-Sleep -Seconds 5
Add-Printer -DriverName "HP Universal Printing PCL 6" -Name "PRINTER MAR-B110 Learning Center" -PortName "10.60.10.19"
