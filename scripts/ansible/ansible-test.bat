@echo off
@setlocal enableextensions enabledelayedexpansion

set "tmpfile=%TEMP%\ansible-test-%RANDOM%"
set RC=0

set args=--extra-vars var1=value1
set expect=--extra-vars 'var1=value1'
call :check

set args=--extra-vars var1="value1"
set expect=--extra-vars 'var1=\"value1\"'
call :check

set args=--extra-vars "var1=value1"
set expect=--extra-vars 'var1=value1'
call :check

set args=--extra-vars {"node_ip":"192.168.50.10"}
set expect=--extra-vars '{\"node_ip\":\"192.168.50.10\"}'
call :check

set args=--extra-vars '{"node_ip":"192.168.50.10"}'
set expect=--extra-vars '{\"node_ip\":\"192.168.50.10\"}'
call :check

set args=--extra-vars "{"node_ip":"192.168.50.10"}"
set expect=--extra-vars '{\"node_ip\":\"192.168.50.10\"}'
call :check

set args=--ssh-extra-args "'-o IdentitiesOnly=yes'"
set expect=--ssh-extra-args \"'-o IdentitiesOnly=yes'\"
call :check

set args=--extra-vars "ansible_ssh_pass=vagrant test_var=\"{}hi' $there\""
set expect=--extra-vars 'ansible_ssh_pass=vagrant test_var=\"{}hi'\"'\"' \$there\"'
call :check

set args=--extra-vars "{\"no'de\":\"hel'lo test'\"}"
set expect=--extra-vars '{\"no'\"'\"'de\":\"hel'\"'\"'lo test'\"'\"'\"}'
call :check

echo.
if "%RC%"=="0" ( echo TEST SUCCEEDED ) else echo TEST FAILED
exit /b %RC%

:check
set _args=%args%
set _expect=%expect%
if "%args:~0,13%"=="--extra-vars " (
	set args=%_args:--extra-vars =-e %
	set expect=%_expect:--extra-vars =-e %
	call :checkargs

	set args=%_args:--extra-vars =-e=%
	set expect=%_expect:--extra-vars =-e=%
	call :checkargs

	set x=!_args:"=#!
	if "!x:~0,15!"=="--extra-vars #{" (
		set args=#-e=!x:~14!
		set args=!args:#="!
		set expect=!_expect:--extra-vars =-e=!
		call :checkargs
	)

	set args=%_args%
	set expect=%_expect%
	call :checkargs

	set args=%_args:--extra-vars =--extra-vars=%
	set expect=%_expect:--extra-vars =--extra-vars=%
	call :checkargs

	set x=!_args:"=#!
	if "!x:~0,15!"=="--extra-vars #{" (
		set args=#--extra-vars=!x:~14!
		set args=!args:#="!
		call :checkargs
	)
) else (
	call :checkargs
)
exit /b 0

:checkargs
echo %args%| sed -f "%~dp0\ansible.sed" > "%tmpfile%"
set /p out=<"%tmpfile%"
del "%tmpfile%"
set x=%out:"=#%
set y=%expect:"=#%
if "%x%"=="%y%" (
	echo OK       %args% -^> %out%
) else (
	echo FAILED   %args%
	echo EXPECTED %expect%
	echo GOT      %out%
	set RC=1
)
exit /b 0
