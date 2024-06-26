# PowerShell script to download and run an exe with arguments

# Define the URL of the exe file
$exe_url = "https://www.dropbox.com/scl/fi/jv2r9pazr3rryhc049hqh/FaronicsCleanupUtility.exe?rlkey=dpz5yle5y1hmh3i63lriffgwy&st=zew5ol98&dl=1"

# Define the arguments for the exe
# $exe_arguments = "/arg1 value1 /arg2 value2"

# Define the path where the exe will be downloaded
$download_path = "C:\ITS\"

# Define the name of the downloaded exe file
$exe_filename = "FaronicsCleanupUtility.exe"

# Construct the full path to the downloaded exe
$full_exe_path = $download_path + $exe_filename

# Download the exe using PowerShell
Invoke-WebRequest -Uri $exe_url -OutFile $full_exe_path

# Run the exe with arguments using PowerShell
# Start-Process $full_exe_path -ArgumentList $exe_arguments

# Run the exe without arguments using PowerShell
Start-Process $full_exe_path
