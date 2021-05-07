@echo off
@setlocal enableextensions enabledelayedexpansion

net session >nul: 2>&1
if errorlevel 1 (
	echo %0 must be run with Administrator privileges
	goto :eof
)

set "PATH=%ALLUSERSPROFILE%\chocolatey\bin;%PATH%"
where /q choco
if errorlevel 1 (
	powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
	if errorlevel 1 goto :eof
)

set "PATH=%ProgramFiles%\Git\bin;%PATH%"
where /q git
if errorlevel 1 (
	echo Installing Git ...
	choco install git -y -r
	if errorlevel 1 goto :eof
)

echo Install WSL, then install Vagrant in WSL
goto :eof

set "PATH=%SystemDrive%\HashiCorp\Vagrant\bin;%PATH%"
where /q vagrants
if not errorlevel 1 (
	echo Installing Vagrant ...
	choco install vagrant -y -r
	if errorlevel 1 goto :eof
	echo Please reboot the system
	goto :eof
)