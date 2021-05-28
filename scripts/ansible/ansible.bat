@echo off
@setlocal enableextensions enabledelayedexpansion

set args=%*

if "%ANSIBLE_ENV%"=="wsl" (
	set "bash=wsl bash"
	set wslpath=wslpath
) else (
	set "bash=%SystemDrive%\tools\cygwin\bin\bash.exe"
	set wslpath=cygpath
	set "PATH=/usr/local/bin;/bin;%PATH%"
)

rem default to ansible command
set ansible=
if not exist "%~dp0\%1.bat" set ansible=ansible

rem escape '\' for pathnames
set args=%args:\=\\\\%

rem adjust quoting of --extra-vars
set args=%args:"--=--%
set args=%args:{"=\\{"%
set args=%args:"}"="\\}%

rem escape special characters
set args=%args:"=\\\"%
set args=%args:$=\\\$%

set "ANSIBLE_SH=%~dp0"
set "ANSIBLE_SH=%ANSIBLE_SH:\=/%ansible.sh"
set "WSLENV=PYTHONUNBUFFERED:ANSIBLE_NOCOLOR:ANSIBLE_HOST_KEY_CHECKING:ANSIBLE_SSH_ARGS:ANSIBLE_SH:%WSLENV%"

if "%ANSIBLE_ENV%"=="wsl" (
	rem Filter the output from WSL to convert <LF> to <CR> <BS> <LF>
	rem which seems to behave reasonably with both Packer and Vagrant.
	%bash% -c """$(%wslpath% -u ""$ANSIBLE_SH"")"" %ansible% %args%" | sed -ub -e"s?\r*$?\r\ch?"
) else (
	%bash% -c """$(%wslpath% -u ""$ANSIBLE_SH"")"" %ansible% %args%"
)
