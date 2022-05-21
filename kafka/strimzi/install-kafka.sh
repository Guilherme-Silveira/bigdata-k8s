#!/bin/bash

kubectl create namespace strimzi-operator
kubectl apply -f strimzi-operator.yaml
kubectl apply -f kafka-cluster.yaml