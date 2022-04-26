REM This batch file will attempt to do an in-place upgrade to Windows 10 64-bit version 21H2 from an ISO-Extracted source.

:start
\\centralaz\shares\Tech\Support_Services\21H2_SetupEXE_PS_Upgrade\W10_21H2_ISO\setup.exe /migchoice upgrade /showoobe none /eula accept /DynamicUpdate disable /Telemetry Disable /quiet

:end
exit
