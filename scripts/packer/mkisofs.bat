@echo off
@setlocal enableextensions enabledelayedexpansion

set "PATH=%ProgramFiles(x86)%\cdrtfe\tools\cdrtools;%ProgramFiles(x86)%\cdrtfe\tools\cygwin;%PATH%"

mkisofs.exe %*
