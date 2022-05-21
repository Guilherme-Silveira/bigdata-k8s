#!/bin/bash

helm repo add trino https://trinodb.github.io/charts/
helm install tcb trino/trino -f values.yaml --version 0.8.0 --namespace bigdata
kubectl apply -f ingress.yaml