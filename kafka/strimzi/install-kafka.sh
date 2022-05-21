#!/bin/bash

kubectl apply -f strimzi-operator.yaml
kubectl apply -f kafka-cluster.yaml
