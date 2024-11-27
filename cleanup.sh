kubectl --kubeconfig=first.cfg -n east delete -f ./cluster-init-g1.yaml
kubectl --kubeconfig=second.cfg -n west delete accesstoken/west-to-east
kubectl --kubeconfig=first.cfg delete -f ./east.yaml
kubectl --kubeconfig=second.cfg delete -f ./west.yaml

