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

The Windows box files seem to be too large to upload reliably through the website.
Instead use:

~~~sh
set ATLAS_TOKEN=<....>
vagrant cloud provider upload nconnolly1/windows-2019 hyperv 1.0.0 windows-2019-standard-hyperv.box
~~~

To use a null builder:

~~~sh
    {
      "type": "null",
      "communicator": "winrm",
      "winrm_username": "vagrant",
      "winrm_password": "vagrant",
      "winrm_host": "ip-address"
     }
~~~
