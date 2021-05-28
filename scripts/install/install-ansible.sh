#!/usr/bin/env bash

sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

sudo apt install pip -y
sudo python3 -m pip install pywinrm==0.4.2
