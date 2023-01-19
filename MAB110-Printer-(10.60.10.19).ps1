$MYPRINTERDRV = "HP Universal Printing PCL 6"
$MYPRINTER = "HP PRINTER MAR-B110 Learning Center"
$MYPRINTERIP = "10.60.10.19"

Get-Printer | Where-Object { $_.Name -notmatch "PDF" } | Remove-Printer
Start-Sleep -Seconds 5
Add-PrinterPort -Name $MYPRINTERIP -PrinterHostAddress $MYPRINTERIP
Start-Sleep -Seconds 5
Add-Printer -DriverName $MYPRINTERDRV -Name $MYPRINTER -PortName $MYPRINTERIP
Start-Sleep -Seconds 5

$PRINTERTMP = (Get-CimInstance -ClassName CIM_Printer | WHERE {$_.Name -eq $MYPRINTER}[0])
$PRINTERTMP | Invoke-CimMethod -MethodName SetDefaultPrinter | Out-Null
