Add-PrinterPort -Name "10.70.10.14" -PrinterHostAddress "10.70.10.14"
Start-Sleep -Seconds 5
pnputil.exe /a "\\spcstuapps01\Software\Drivers\HP Universal Print Driver\pcl6-x64-7.0.1.24923\*.inf"
Start-Sleep -Seconds 10
Add-PrinterDriver -Name "HP Universal Printing PCL 6" -InfPath "C:\Windows\System32\DriverStore\FileRepository\hpcu255u.inf_amd64_883dd40f467c5d42\hpcu255u.inf"
Start-Sleep -Seconds 10
Add-Printer -DriverName "HP Universal Printing PCL 6" -Name "PRINTER - Learning Center STC-C117" -PortName "10.70.10.14"