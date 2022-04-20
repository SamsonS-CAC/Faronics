$ErrorActionPreference = "SilentlyContinue"
Start-Process -FilePath C:\$GetCurrent\media\setup.exe -ArgumentList "/migchoice upgrade /showoobe none /eula accept /DynamicUpdate NoDrivers /Telemetry Disable /quiet"
