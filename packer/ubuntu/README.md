# Ubuntu Images

Based on the Packer templates for Ubuntu in the
[Bento](https://github.com/chef/bento/tree/master/packer_templates/ubuntu)
project which are licensed under Apache 2.0.

Setup NATSwitch with external access.

To build an Ubunto 20.04 image:

~~~sh
env.bat
cd packer\ubuntu
packer build -only=hyperv-iso -force -var "hyperv_switch=NATSwitch" .\ubuntu-20.04-amd64.json
~~~

To build an Ubunto 20.04 Kubernetes image:

~~~sh
env.bat
cd packer\ubuntu
packer build -only=hyperv-iso -force -var "hyperv_switch=NATSwitch" .\ubuntu-20.04-k8s-amd64.json
~~~

Templates for other versions of Ubuntu can be found in the
[Bento](https://github.com/chef/bento/tree/master/packer_templates/ubuntu)
project.

To use a null builder:

~~~sh
    {
      "type": "null",
      "ssh_host": "ip-address",
      "ssh_username": "vagrant",
      "ssh_password": "vagrant"
    }
~~~
