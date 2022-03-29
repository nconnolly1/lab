#!/usr/bin/env bash

branch=${1:-v1.0.1}

waitready() {
	x=$( kubectl get --no-headers pods $* | sed -e's? \([0-9][0-9]*\)/\1  *?All ?' | grep -v 'All Running' | wc -l )
	[ "$x" != "0" ] && echo "Waiting for pods to become ready ..."
	while [ "$x" != "0" ]; do
		sleep 1
		x=$( kubectl get --no-headers pods $* | sed -e's? \([0-9][0-9]*\)/\1  *?All ?' | grep -v 'All Running' | wc -l )
	done
}

kubectl label node node-1 openebs.io/engine=mayastor
kubectl label node node-2 openebs.io/engine=mayastor
kubectl label node node-3 openebs.io/engine=mayastor

#
# Create Mayastor Application Resources
#
# Namespace
kubectl create namespace mayastor
# RBAC Resources
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/operator-rbac.yaml
# Custom Resource Definitions
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/mayastorpoolcrd.yaml

#
# Deploy Mayastor Dependencies
#
# NATS
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/nats-deployment.yaml
kubectl -n mayastor get pods --selector=app=nats
# etcd
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/etcd/storage/localpv.yaml
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/etcd/statefulset.yaml 
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/etcd/svc.yaml
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/etcd/svc-headless.yaml
kubectl -n mayastor get pods --selector=app.kubernetes.io/name=etcd

waitready -n mayastor

#
# Deploy Mayastor Components
#
# CSI Node Plugin
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/csi-daemonset.yaml
kubectl -n mayastor get daemonset mayastor-csi
# Core Agents
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/core-agents-deployment.yaml
kubectl get pods -n mayastor --selector=app=core-agents
# REST
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/rest-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/rest-service.yaml
kubectl get pods -n mayastor --selector=app=rest
# CSI Controller
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/csi-deployment.yaml
kubectl get pods -n mayastor --selector=app=csi-controller
# MSP Operator
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/msp-deployment.yaml
kubectl get pods -n mayastor --selector=app=msp-operator
# Data Plane
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/mayastor-daemonset.yaml
kubectl -n mayastor get daemonset mayastor

waitready -n mayastor

# Mayastor Kubectl Plugin
( wget -q -O /tmp/kubectl-mayastor.tar.gz https://github.com/openebs/mayastor-control-plane/releases/download/${branch}/kubectl-mayastor.tar.gz ) </dev/null
tar xvof /tmp/kubectl-mayastor.tar.gz
chmod 0755 kubectl-mayastor
sudo mv -f kubectl-mayastor /usr/bin/kubectl-mayastor
kubectl mayastor get nodes

# Create Storage Pools and Classes
kubectl create -f /vagrant/mayastor/pools.yaml
kubectl create -f /vagrant/mayastor/classes.yaml
kubectl get sc
kubectl -n mayastor get msp

waitready -n mayastor

# Run fio test
cat <<!
kubectl create -f /vagrant/mayastor/pvc-1.yaml
kubectl get pvc ms-volume-claim
kubectl apply -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/fio.yaml
kubectl exec -it fio -- fio --name=benchtest --size=800m --filename=/volume/test --direct=1 --rw=randrw --ioengine=libaio --bs=4k --iodepth=16 --numjobs=8 --time_based --runtime=60
!
