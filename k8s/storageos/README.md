# StorageOS

Requires linux-image-extra-virtual

~~~sh
kubectl label pvc pvc-1 storageos.com/replicas=2
kubectl -n kube-system exec -it cli -- storageos get volumes
~~~
