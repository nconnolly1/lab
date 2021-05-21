# Windows Images

Based on the Packer templates for Windows in the
[Bento](https://github.com/chef/bento/tree/master/packer_templates/windows)
project which are licensed under Apache 2.0.

Setup NATSwitch with external access.

To build a Windows 2019 image:

~~~sh
env.bat
cd boxes\windows
packer build -only=hyperv-iso -force -var "hyperv_switch=NATSwitch" ./windows-2019.json
~~~

To build a Windows 2019 Hyper-V image (Gen 2):

~~~sh
env.bat
cd boxes\windows
createiso.bat 2019
packer build -only=hyperv-iso -force -var "hyperv_switch=NATSwitch" ./windows-2019gen2.json
~~~

Templates for other versions of Windows can be found in the
[Bento](https://github.com/chef/bento/tree/master/packer_templates/windows)
project.
