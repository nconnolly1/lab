Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

$AppxFile = $env:TEMP + '\Ubuntu2004.appx'
$ZipFile = $env:TEMP + '\Ubuntu2004.zip'
$WslDir = $env:LOCALAPPDATA + '\Packages\Ubuntu2004'
$WslExe = $WslDir + '\ubuntu2004.exe'

Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile $AppxFile -UseBasicParsing

Rename-Item $AppxFile $ZipFile
Expand-Archive $ZipFile $WslDir

& $WslExe
