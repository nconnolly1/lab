#!/usr/bin/env bash

PKG=/tmp/vagrant_2.2.16_x86_64.deb
curl -o "$PKG" https://releases.hashicorp.com/vagrant/2.2.16/vagrant_2.2.16_x86_64.deb
sudo apt install "$PKG"
rm -f "$PKG"

sudo apt install ansible
sudo python3 -m pip install pywinrm==0.4.2
