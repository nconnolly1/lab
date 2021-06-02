#!/usr/bin/env bash

branch=develop

kubectl label node node-1 openebs.io/engine=mayastor
kubectl label node node-2 openebs.io/engine=mayastor
kubectl label node node-3 openebs.io/engine=mayastor

kubectl create namespace mayastor
kubectl create -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/moac-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/csi/moac/crds/mayastorpool.yaml

kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/nats-deployment.yaml
kubectl -n mayastor get pods --selector=app=nats

kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/csi-daemonset.yaml
kubectl -n mayastor get daemonset mayastor-csi

kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/etcd/svc.yaml
kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/etcd/svc-headless.yaml
kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/etcd/statefulset.yaml

kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/moac-deployment.yaml
kubectl get pods -n mayastor --selector=app=moac

kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/mayastor-daemonset.yaml
kubectl -n mayastor get daemonset mayastor

kubectl -n mayastor get msn

kubectl create -f /vagrant/mayastor/pools.yaml
kubectl create -f /vagrant/mayastor/classes.yaml
kubectl get sc
kubectl -n mayastor get msp

# kubectl create -f /vagrant/mayastor/pvc-1.yaml
# kubectl get pvc ms-volume-claim

# kubectl apply -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/fio.yaml
