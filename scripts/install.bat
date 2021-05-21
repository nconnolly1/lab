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

where /q packer
if errorlevel 1 (
	echo Installing Packer ...
	choco install packer -y -r
	if errorlevel 1 goto :eof
)

where /q terraform
if errorlevel 1 (
	echo Installing Terraform ...
	choco install terraform -y -r
	if errorlevel 1 goto :eof
)

where /q cygwin
if errorlevel 1 (
	echo Installing Cygwin ...
	choco install cygwin cyg-get -y -r
	if errorlevel 1 goto :eof
)

set "CYGWIN=%SystemDrive%\tools\cygwin"

if not exist "%CYGWIN%\bin\genisoimage.exe" (
	echo Installing Cygwin genisoimage ...
	call cyg-get genisoimage
)

if not exist "%CYGWIN%\usr\local\bin\ansible" (
	echo Installing Cygwin Ansible ...
	call cyg-get openssh python38 python38-pip python38-devel libssl-devel libffi-devel gcc-g++ python38-cryptography
	"%CYGWIN%\bin\bash" --login -c "/usr/bin/python3.8.exe -m pip install wheel ansible"
)

set "PATH=%SystemDrive%\HashiCorp\Vagrant\bin;%PATH%"
where /q vagrant
if errorlevel 1 (
	echo Installing Vagrant ...
	choco install vagrant -y -r
	if errorlevel 1 goto :eof
	echo Please reboot the system
	goto :eof
)

echo To run from WSL, install WSL, then install Vagrant in WSL and update env.bat
