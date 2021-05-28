@echo off
@setlocal enableextensions enabledelayedexpansion

net session >nul: 2>&1
if errorlevel 1 (
	echo %0 must be run with Administrator privileges
	goto :eof
)

where /q cygwin
if errorlevel 1 (
	echo Installing Cygwin ...
	choco install cygwin cyg-get -y -r
	if errorlevel 1 goto :eof
)

set "CYGWIN=%SystemDrive%\tools\cygwin"

if not exist "%CYGWIN%\usr\local\bin\ansible" (
	echo Installing Cygwin Ansible ...
	call cyg-get openssh python38 python38-pip python38-devel libssl-devel libffi-devel gcc-g++ python38-cryptography
	"%CYGWIN%\bin\bash" --login -c "/usr/bin/python3.8.exe -m pip install wheel \"ansible==3.4.0\" pywinrm"
)
