echo =======================
echo batch file to delete "CAC-M365-Repeat-Install-Bug" folder
echo =======================

timeout 2
echo Removing the task >> "Install O365 on Reboot"
schtasks /delete /TN "Install O365 on Reboot" /F

timeout 2
echo Removing the folder >> "C:\ITS\M365"
rmdir C:\ITS\M365 /S /Q

timeout 2

echo Run Office M365 Updater
cd C:\Program Files\Common Files\Microsoft Shared\ClickToRun
OfficeC2RClient.exe /update user forceappshutdown=false