@echo off

set "PATH=%~dp0\scripts\ansible;%PATH%"

set ANSIBLE_ENV=cygwin
set PACKER_CACHE_DIR=%USERPROFILE%\.packer\cache
set VAGRANT_DISABLE_SMBMFSYMLINKS=1
