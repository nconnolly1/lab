# Windows Images

Based on the Packer templates for Windows in the
[Bento](https://github.com/chef/bento/tree/master/packer_templates/windows)
project which are licensed under Apache 2.0.

To build a Windows 2019 image:

~~~sh
env.bat
cd boxes\windows
packer build -only=hyperv-iso -force ./windows-2019.json
~~~

**NB. Change the network to Default Switch as soon as the Vm is created.**

Templates for other versions of Windows can be found in the
[Bento](https://github.com/chef/bento/tree/master/packer_templates/windows)
project.
