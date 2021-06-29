# Portworx

~~~sh
kubectl label nodes node-1 node-2 node-3 px/metadata-node=true
kubectl apply -f portworx_enterprise.yaml
kubectl apply -f sc.yaml
kubectl create -f pvc-1.yaml
kubectl -f apply fio.yaml

PX_POD=$(kubectl get pods -l name=portworx -n kube-system -o jsonpath='{.items[0].metadata.name}')
kubectl exec $PX_POD -n kube-system -- /opt/pwx/bin/pxctl status
~~~