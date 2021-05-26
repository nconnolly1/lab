# basebox
Create Vagrant Base image for Kubernetes cluster.

~~~sh
vagrant up
~~~

In Hyper-V move the boot disk to the top of the boot order.

~~~sh
vagrant ssh
sudo apt-get clean
cat /dev/null > ~/.bash_history && history -c && exit
~~~

~~~sh
vagrant package --output ubuntu-20.04-k8s.box
~~~

Upload package to Vagrant Cloud

~~~sh
vagrant box add nconnolly1/ubuntu-20.04-k8s ubuntu-20.04-k8s.box
rm -f ubuntu-20.04-k8s.box
~~~
