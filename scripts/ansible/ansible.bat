@echo off
@setlocal enableextensions enabledelayedexpansion

rem default to ansible command
set args=%*
if not exist "%~dp0\%1.bat" set "args=ansible %args%"

set "v=%args:* -vv=%"
if "%v:~0,1%"=="v" echo Running Ansible.bat: %args%

rem quote arguments
set "tmpfile=%TEMP%\ansible-args%RANDOM%"
echo %args%| sed -f "%~dp0\ansible.sed" > "%tmpfile%"
set /p args=<"%tmpfile%"
del "%tmpfile%"

if "%v:~0,1%"=="v" echo Executing Ansible.sh: %args%

set "ANSIBLE_SH=%~dp0"
set "ANSIBLE_SH=%ANSIBLE_SH:\=/%ansible.sh"

if "%ANSIBLE_ENV%"=="docker" (
	call :wslpath %HOMEDRIVE%\ home
	call :wslpath %CD% work
	call :wslpath %ANSIBLE_SH% sh
	docker run -v %HOMEDRIVE%\:!home! -v %CD:~0,2%\:!work:~0,7! ^
		-v %ANSIBLE_SH:~0,2%\:!sh:~0,7! -w !work! -e ANSIBLE_SSH_ARGS="%ANSIBLE_SSH_ARGS%" ^
		-e PYTHONUNBUFFERED="%PYTHONUNBUFFERED%" -e ANSIBLE_NOCOLOR="%ANSIBLE_NOCOLOR%" ^
		-e ANSIBLE_HOST_KEY_CHECKING="%ANSIBLE_HOST_KEY_CHECKING%" ^
		--entrypoint="/usr/bin/bash" --rm nconnolly/ansible -c "!sh! %args%"
) else if "%ANSIBLE_ENV:~0,3%"=="wsl" (
	rem Filter the output from WSL to convert <LF> to <CR> <BS> <LF>
	rem which seems to behave reasonably with both Packer and Vagrant.
	rem Preserving the return code is based on the technique in:
	rem https://stackoverflow.com/questions/11170753/windows-command-interpreter-how-to-obtain-exit-code-of-first-piped-command
	set rc=0
	set "WSLENV=PYTHONUNBUFFERED:ANSIBLE_NOCOLOR:ANSIBLE_HOST_KEY_CHECKING:ANSIBLE_SSH_ARGS:ANSIBLE_SH:%WSLENV%"
	( %ANSIBLE_ENV% bash -c """$(wslpath -u ""$ANSIBLE_SH"")"" %args%" &^
		call doskey /exename=ansible rc=%%^^errorlevel%% ) | sed -ub -e"s?\r*$?\r\ch?"
	for /f "tokens=2 delims==" %%r in ('doskey /m:ansible') do set rc=%%r
	doskey /exename=ansible rc=
	exit /b !rc!
) else if "%ANSIBLE_ENV%"=="cygwin" (
	set "PATH=/usr/local/bin;/bin;%PATH%"
	"%SystemDrive%\tools\cygwin\bin\bash.exe" -c """$(cygpath -u ""$ANSIBLE_SH"")"" %args%"
) else (
	echo Error: ANSIBLE_ENV is set to "%ANSIBLE_ENV%"
	exit /b 3
)
exit /b %errorlevel%

:wslpath
rem path translation for docker
echo %1| sed -e"s?\\?/?g;s?^\(.\):/?/mnt/\l\1/?" > "%tmpfile%"
set /p %2=<"%tmpfile%"
del "%tmpfile%"
goto :eof
