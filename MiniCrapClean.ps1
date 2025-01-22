$tempfolders = @("C:\Windows\Temp\*","C:\Windows\Prefetch\*","C:\Documents and Settings\*\Local Settings\temp\*","C:\Users\*\Appdata\Local\Temp\*", ":\$Recycle.Bin\*")
Remove-Item $tempfolders -force -recurse
