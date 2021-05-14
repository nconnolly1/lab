# Mayastor

~~~sh
kubectl label node node-1 openebs.io/engine=mayastor
kubectl label node node-2 openebs.io/engine=mayastor
kubectl label node node-3 openebs.io/engine=mayastor
~~~

~~~sh
kubectl create namespace mayastor
kubectl create -f https://raw.githubusercontent.com/openebs/Mayastor/develop/deploy/moac-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/develop/csi/moac/crds/mayastorpool.yaml
~~~

~~~sh
kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/develop/deploy/nats-deployment.yaml
kubectl -n mayastor get pods --selector=app=nats
~~~

~~~sh
kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/develop/deploy/csi-daemonset.yaml
kubectl -n mayastor get daemonset mayastor-csi
~~~

~~~sh
kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/develop/deploy/moac-deployment.yaml
kubectl get pods -n mayastor --selector=app=moac
~~~

~~~sh
kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/develop/deploy/mayastor-daemonset.yaml
kubectl -n mayastor get daemonset mayastor
~~~

~~~sh
kubectl -n mayastor get msn
~~~

~~~sh
kubectl create -f /vagrant/mayastor/pools.yaml
kubectl create -f /vagrant/mayastor/classes.yaml
kubectl get sc
kubectl -n mayastor get msp
~~~

~~~sh
kubectl create -f /vagrant/mayastor/pvc-1.yaml
kubectl get pvc ms-volume-claim
~~~

~~~sh
kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/develop/deploy/fio.yaml
~~~
