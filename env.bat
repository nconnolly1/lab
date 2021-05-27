@echo off

set "PATH=%~dp0\scripts\ansible;%PATH%"

rem Could select wsl dynamically based on result of
rem wsl ansible --version >nul: 2>&1 && check %errorlevel%==0

set ANSIBLE_ENV=cygwin
set PACKER_CACHE_DIR=%USERPROFILE%\.packer\cache
set VAGRANT_DISABLE_SMBMFSYMLINKS=1
