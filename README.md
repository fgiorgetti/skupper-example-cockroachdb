# skupper-example-cockroachdb

Simple example of a cockroachdb cluster over two different kubernetes
clusters using skupper. This is based on the example from
https://github.com/cockroachdb/cockroach/tree/master/cloud/kubernetes

# Setup

You need two kubernetes clusters, the first of of which must be
accessible by the other. Note: at present the namespaces on each of
these clusters must have the same name.

In the first kubernetes cluster:

1. create the cockroachdb statefulset

```kubectl apply -f ./cockroachdb-statefulset-g1.yaml```

2. once those pods are running, initialise the cluster

```kubectl apply -f ./cluster-init-g1.yaml```

3. initialise skupper

```skupper init```

4. expose the statefulset's headless service to the skupper network:

```skupper expose statefulset cockroachdb-g1 --headless --port 26257```

5. create a connection token with which the second kubernetes cluster
will connect to this first one

```skupper connection-token site-one.yaml```

Now in the second kubernetes cluster:

6. initialise skupper

```skupper init```

7. connect the two skupper sites using the connection token created in step 5

```skupper connect site-one.yaml```

8. create another cockroachdb statefulset in the second cluster

```kubectl apply -f ./cockroachdb-statefulset-g2.yaml```

9. expose the headless service of this second statefulset also:

```skupper expose statefulset cockroachdb-g2 --headless --port 26257```

Once everything has initialised you can verify the cockroachdb cluster now has 5 members by port forwarding on the first cluster:

```kubectl port-forward cockroachdb-g1-0 8080```

and then accessing http://localhost:8080 with your browser

You can then e.g. scale up the statefulset on the second kubernetes
cluster and verify that the console eventually shows 6 nodes.