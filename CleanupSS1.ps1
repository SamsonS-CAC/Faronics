## BEGIN ##

## 1 ## Disable Hibernation File ##
write-Host "______________________________________________________________________"
write-Host ">>>> TASK 01 >>>> Disable Hibernation File >>>> ... "
powercfg /h off
start-sleep 2
write-Host ">>>> TASK 01 >>>> Disable Hibernation File >>>> SUCCESS!!!"
start-sleep 2


## 2 ## Clear Temp Folders and Recycle Bin ##
write-Host "______________________________________________________________________"
write-Host ">>>> TASK 02 >>>> Clear Temp Folders and Recycle Bin >>>> ... "
$tempfolders = @("C:\Windows\Temp\*","C:\Windows\Prefetch\*","C:\Documents and Settings\*\Local Settings\temp\*","C:\Users\*\Appdata\Local\Temp\*", ":\$Recycle.Bin\*")
Remove-Item $tempfolders -force -recurse
start-sleep 2
write-Host ">>>> TASK 02 >>>> Clear Temp Folders and Recycle Bin >>>> SUCCESS!!!"
start-sleep 2

## END ##
