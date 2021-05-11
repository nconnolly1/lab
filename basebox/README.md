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
vagrant package --output basebox.box
vagrant box add nconnolly1/basebox basebox.box
~~~
