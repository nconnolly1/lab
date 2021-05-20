@echo off

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

rem remove quotes from "--extra-vars={...}"
set args=%args:"--=--%
set args=%args:"}"="}%

rem escape any quotes
set args=%args:"=\\\"%

set "ANSIBLE_SH=%~dp0"
set "ANSIBLE_SH=%ANSIBLE_SH:\=/%ansible.sh"
set "WSLENV=PYTHONUNBUFFERED:ANSIBLE_NOCOLOR:ANSIBLE_HOST_KEY_CHECKING:ANSIBLE_SSH_ARGS:ANSIBLE_SH:%WSLENV%"

%bash% -c """$(%wslpath% -u ""$ANSIBLE_SH"")"" %ansible% %args%"
