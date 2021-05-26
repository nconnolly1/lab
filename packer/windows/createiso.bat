@echo off

set OS=%1
if "%OS%"=="" set OS=2019

set TMPDIR=..\..\builds\tmp

rmdir /s /q "%TMPDIR%" 2>nul:
mkdir "%TMPDIR%"

copy "answer_files\%OS%\gen2_Autounattend.xml" "%TMPDIR%\Autounattend.xml"
copy "scripts\base_setup.ps1" "%TMPDIR%\base_setup.ps1"

set "PATH=/usr/local/bin;/bin;%PATH%"
"%SystemDrive%\tools\cygwin\bin\bash.exe" -c "cd ../../builds; genisoimage -o secondary.iso -J -R tmp"

rmdir /s /q "%TMPDIR%"
