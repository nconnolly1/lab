# Lab Environments

Create lab environments using Vagrant, Packer and Ansible.

## Installation

To get started run the following from an elevated command prompt
in a suitable folder:

~~~sh
curl -LJ -o .\install.bat https://raw.githubusercontent.com/nconnolly1/lab/main/scripts/install.bat
.\install.bat
~~~

The code can them be extracted with:

~~~sh
git clone https://github.com/nconnolly1/lab
cd lab
~~~

### Install Ansible

Ansible is not officially supported on Windows. It can be run under Cygwin, but according to the Ansible website this is not recommended for production use.

Ansible is supported on the Windows Subsystem for Linux (WSL 1) which can be setup from an elevated PowerShell prompt on Windows Server using:

~~~sh
.\scripts\install\install-wsl-server.ps1
wsl bash -c ./scripts/install/install-ansible.sh
~~~

If WSL is not available, Ansible can be install under Cygwin from an elevated command prompt with:

~~~sh
.\install\install-cygwin.bat
~~~

## Notes

### Kubernetes Cluster

The Kubernetes Cluster is based on the instructions in a
[Kubernetes Blog post](https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/).

### Ansible for Windows

Installation is based on the blog
[Quick Ansible Setup](https://www.arsano.ninja/2020/09/18/simple-ansible-setup-with-cygwin/)
