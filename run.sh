kubectl --kubeconfig=first.cfg apply -f ./east.yaml
kubectl --kubeconfig=second.cfg apply -f ./west.yaml
kubectl --kubeconfig=first.cfg -n east wait --for=condition=ready accessgrant/east-grant --timeout 5m && kubectl --kubeconfig=first.cfg -n east get accessgrant east-grant -o templatefile --template accesstoken.template | kubectl  --kubeconfig=second.cfg -n west apply -f -
kubectl --kubeconfig=first.cfg -n east wait --for=jsonpath='{.status.phase}'=Running pod/cockroachdb-g1-0 --timeout 5m && kubectl --kubeconfig=first.cfg -n east apply -f ./cluster-init-g1.yaml
