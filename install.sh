#!/usr/bin/env bash

PKG=/tmp/vagrant_2.2.15_x86_64.deb
curl -o "$PKG" https://releases.hashicorp.com/vagrant/2.2.15/vagrant_2.2.15_x86_64.deb
sudo apt install "$PKG"
rm -f "$PKG"

exit 0

# Temporary
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/mnt/c/Windows/System32:/mnt/c/Windows:/mnt/c/Windows/System32/wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0:/mnt/c/Windows/System32/OpenSSH:/mnt/c/Program Files (x86)/Windows Kits/10/Windows Performance Toolkit:/mnt/c/ProgramData/chocolatey/bin:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/Nick/AppData/Local/Microsoft/WindowsApps:/snap/bin
