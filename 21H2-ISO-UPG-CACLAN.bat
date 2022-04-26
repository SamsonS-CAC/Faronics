REM This batch file will attempt to do in-place upgrade to Windows 10 version 21H2 from the ISO-Extracted source.
REM This is for the 64-bit version, which should be most computers, if not all. 
REM This batch file checks and verifies make sure the target system is 64-bit first before running.

@echo off

dir /s %windir%\Web\4K
if not errorlevel 1 goto end

dir /s %systemdrive%\Program Files (x86)\Windows Defender
if not errorlevel 1 goto start

:start
\\centralaz\shares\Tech\Support_Services\21H2_SetupEXE_PS_Upgrade\W10_21H2_ISO\setup.exe /auto upgrade /showoobe None /DynamicUpdate disable

:end
exit