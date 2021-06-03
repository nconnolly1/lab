#!/usr/bin/env bash

branch=${1:-develop}

kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/fio.yaml
kubectl delete -f /vagrant/mayastor/pvc-1.yaml
kubectl delete -f /vagrant/mayastor/pvc-2.yaml
kubectl delete -f /vagrant/mayastor/pvc-3.yaml
kubectl delete -f /vagrant/mayastor/pools.yaml
kubectl delete -f /vagrant/mayastor/classes.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/mayastor-daemonset.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/moac-deployment.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/etcd/statefulset.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/etcd/svc-headless.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/etcd/svc.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/csi-daemonset.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/nats-deployment.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/deploy/moac-rbac.yaml
kubectl delete -f https://raw.githubusercontent.com/openebs/Mayastor/${branch}/csi/moac/crds/mayastorpool.yaml
kubectl delete namespace mayastor

kubectl label node node-1 openebs.io/engine=mayastor-
kubectl label node node-2 openebs.io/engine=mayastor-
kubectl label node node-3 openebs.io/engine=mayastor-
