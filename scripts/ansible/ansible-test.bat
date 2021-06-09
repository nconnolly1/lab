@echo off
@setlocal enableextensions enabledelayedexpansion

set "tmpfile=%TEMP%\ansible-test-%RANDOM%"
set RC=0

set args=-e var1=value1
set expect=-e 'var1=value1'
call :check

set args=-e var1="value1"
set expect=-e 'var1=\"value1\"'
call :check

set args=-e "var1=value1"
set expect=-e 'var1=value1'
call :check

set args=-e {"node_ip":"192.168.50.10"}
set expect=-e '{\"node_ip\":\"192.168.50.10\"}'
call :check

set args=-e "{"node_ip":"192.168.50.10"}"
set expect=-e '{\"node_ip\":\"192.168.50.10\"}'
call :check

set args=--ssh-extra-args "'-o IdentitiesOnly=yes'"
set expect=--ssh-extra-args \"'-o IdentitiesOnly=yes'\"
call :check

set args=-e "ansible_ssh_pass=vagrant test_var=\"{}hi' $there\""
set expect=-e 'ansible_ssh_pass=vagrant test_var=\"{}hi'\"'\"' \$there\"'
call :check

set args=-e "{\"no'de\":\"hel'lo test'\"}"
set expect=-e '{\"no'\"'\"'de\":\"hel'\"'\"'lo test'\"'\"'\"}'
call :check

echo.
if "%RC%"=="0" ( echo TEST SUCCEEDED ) else echo TEST FAILED
exit /b %RC%

:check
call :checkargs
if "%args:~0,3%"=="-e " (
	set args=%args:-e =--extra-vars %
	set expect=%expect:-e =--extra-vars %
	call :checkargs
)
if "%args:~0,13%"=="--extra-vars " (
	set args=%args:--extra-vars =--extra-vars=%
	set expect=%expect:--extra-vars =--extra-vars=%
	call :checkargs
)
set x=%args:"=#%
if "%x:~0,15%"=="--extra-vars=#{" (
	set args=#--extra-vars=%x:~14%
	set args=!args:#="!
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
