@echo off
@setlocal enableextensions enabledelayedexpansion

set args=%*

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

if "%ANSIBLE_ENV%"=="docker" (
	call :wslpath %HOMEDRIVE%\ home
	call :wslpath %CD% work
	call :wslpath %ANSIBLE_SH% sh
	docker run -v %HOMEDRIVE%\:!home!:ro -v %CD:~0,2%\:!work:~0,7!:ro ^
		-v %ANSIBLE_SH:~0,2%\:!sh:~0,7!:ro -w !work! -e ANSIBLE_SSH_ARGS="%ANSIBLE_SSH_ARGS%" ^
		-e PYTHONUNBUFFERED="%PYTHONUNBUFFERED%" -e ANSIBLE_NOCOLOR="%ANSIBLE_NOCOLOR%" ^
		-e ANSIBLE_HOST_KEY_CHECKING="%ANSIBLE_HOST_KEY_CHECKING%" ^
		--entrypoint="/usr/bin/bash" --rm nconnolly/ansible -c "!sh! %ansible% %args%"
) else if "%ANSIBLE_ENV%"=="wsl" (
	rem Filter the output from WSL to convert <LF> to <CR> <BS> <LF>
	rem which seems to behave reasonably with both Packer and Vagrant.
	wsl bash -c """$(wslpath -u ""$ANSIBLE_SH"")"" %ansible% %args%" | sed -ub -e"s?\r*$?\r\ch?"
) else if "%ANSIBLE_ENV%"=="cygwin" (
	set "PATH=/usr/local/bin;/bin;%PATH%"
	"%SystemDrive%\tools\cygwin\bin\bash.exe" -c """$(cygpath -u ""$ANSIBLE_SH"")"" %ansible% %args%"
)
goto :eof

:wslpath
rem path translation for docker
set arg=%1
set "arg=%arg:\=/%"
if "%arg:~1,2%"==":/" (
	set x=%arg:~0,1%
	for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do set x=!x:%%i=%%i!
	set "arg=/mnt/!x!%arg:~2%"
)
set "%2=%arg%"
goto :eof
