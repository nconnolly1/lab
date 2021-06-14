#!/usr/bin/env bash

branch=${1:-develop}

kube () {
	if [ -f "/vagrant/mayastor/${branch}/$3" ]
	then
		echo kubectl $1 $2 "/vagrant/mayastor/${branch}/$3"
		kubectl $1 $2 "/vagrant/mayastor/${branch}/$3"
	elif [ -f "/vagrant/mayastor/yamls/$3" ]
	then
		echo kubectl $1 $2 "/vagrant/mayastor/yamls/$3"
		kubectl $1 $2 "/vagrant/mayastor/yamls/$3"
	elif [ "$3" = "mayastorpoolcrd.yaml" ]
	then
		echo kubectl $1 $2 "https://raw.githubusercontent.com/openebs/Mayastor/${branch}/csi/moac/crds/mayastorpool.yaml"
		kubectl $1 $2 "https://raw.githubusercontent.com/openebs/Mayastor/${branch}/csi/moac/crds/mayastorpool.yaml"
	else
		echo kubectl $1 $2 "https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/$3"
		kubectl $1 $2 "https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/$3"
	fi
}

cat "$(dirname "${BASH_SOURCE[0]}")/fetch-yamls.sh" |
	( cd /vagrant/mayastor; rm -rf yamls; bash -s - "${branch}" )

kubectl label node node-1 openebs.io/engine=mayastor
kubectl label node node-2 openebs.io/engine=mayastor
kubectl label node node-3 openebs.io/engine=mayastor

kubectl create namespace mayastor
kube create -f moac-rbac.yaml
kube apply -f mayastorpoolcrd.yaml

kube apply -f nats-deployment.yaml
kubectl -n mayastor get pods --selector=app=nats

kube apply -f csi-daemonset.yaml
kubectl -n mayastor get daemonset mayastor-csi

kube apply -f etcd/svc.yaml
kube apply -f etcd/svc-headless.yaml
kube apply -f etcd/statefulset.yaml

kube apply -f moac-deployment.yaml
kubectl get pods -n mayastor --selector=app=moac
kube apply -f mayastor-daemonset.yaml

kubectl -n mayastor get daemonset mayastor

kubectl -n mayastor get msn

kubectl create -f /vagrant/mayastor/pools.yaml
kubectl create -f /vagrant/mayastor/classes.yaml
kubectl get sc
kubectl -n mayastor get msp

echo kubectl create -f /vagrant/mayastor/pvc-3.yaml
echo kubectl get pvc ms-volume-claim

echo kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/fio.yaml
echo kubectl exec -it fio -- fio --name=benchtest --size=800m --filename=/volume/test --direct=1 --rw=randrw --ioengine=libaio --bs=4k --iodepth=16 --numjobs=8 --time_based --runtime=60
