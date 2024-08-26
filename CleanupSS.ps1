## BEGIN ##

## 0 ## Run PowerShell
powershell
start-sleep 5

## 1 ## Disable Hibernation File ##
powercfg /h off
start-sleep 2
write-Host "Disable Hibernation File = Success."
start-sleep 2

## 2 ## Clear Temp Folders and Recycle Bin ##
$tempfolders = @("C:\Windows\Temp\*","C:\Windows\Prefetch\*","C:\Documents and Settings\*\Local Settings\temp\*","C:\Users\*\Appdata\Local\Temp\*", ":\$Recycle.Bin\*")
Remove-Item $tempfolders -force -recurse
start-sleep 2
write-Host "Clear Temp Folders and Recycle Bin = Success."
start-sleep 2

## 3 ## Run Disk Cleanup Tool ##
cleanmgr /sagerun:1 | out-Null
start-sleep 2
write-Host "Run Disk Cleanup Tool = Success."
start-sleep 2

## END ##
