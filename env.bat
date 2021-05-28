@echo off

set "PATH=%~dp0\scripts\ansible;%~dp0\scripts\packer;%PATH%"

set ANSIBLE_ENV=wsl
wsl ansible --version >nul: 2>&1
if not %errorlevel%==0 set ANSIBLE_ENV=cygwin

set PACKER_CACHE_DIR=%USERPROFILE%\.packer\cache
set VAGRANT_DISABLE_SMBMFSYMLINKS=1
