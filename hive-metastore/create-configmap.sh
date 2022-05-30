#!/bin/bash

kubectl create configmap metastore-cfg --namespace bigdata --dry-run=client --from-file=build/metastore-site.xml --from-file=build/core-site.xml -o yaml | kubectl apply -f -
