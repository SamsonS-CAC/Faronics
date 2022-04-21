$ErrorActionPreference = "SilentlyContinue"
$d = "c:\win10exe"
mkdir -p $d
$ComObj = New-Object System.Net.WebClient
$exedl = "https://go.microsoft.com/fwlink/?LinkID=799445"
$exe = "$($d)\Win10Upgrade.exe"
$ComObj.DownloadFile($exedl,$exe)
Start-Process -FilePath $exe -ArgumentList "/skipeula /auto upgrade /dynamicupdate enable /copylogs $d"
