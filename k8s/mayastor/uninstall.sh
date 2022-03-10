#!/usr/bin/env bash

branch=${1:-v1.0.1}

kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/fio.yaml
kubectl delete -f /vagrant/mayastor/pvc-1.yaml
kubectl delete -f /vagrant/mayastor/pvc-2.yaml
kubectl delete -f /vagrant/mayastor/pvc-3.yaml
kubectl delete -f /vagrant/mayastor/pools.yaml
kubectl delete -f /vagrant/mayastor/classes.yaml

kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/mayastor-daemonset.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/msp-deployment.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/csi-deployment.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/rest-service.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/rest-deployment.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/core-agents-deployment.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/csi-daemonset.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/operator-rbac.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor-control-plane/${branch}/deploy/mayastorpoolcrd.yaml

kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/nats-deployment.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/etcd/svc-headless.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/etcd/svc.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/etcd/statefulset.yaml 
kubectl delete -f https://raw.githubusercontent.com/openebs/mayastor/${branch}/deploy/etcd/storage/localpv.yaml
kubectl delete namespace mayastor

kubectl label node node-1 openebs.io/engine-
kubectl label node node-2 openebs.io/engine-
kubectl label node node-3 openebs.io/engine-
