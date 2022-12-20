#!/bin/bash

helm repo add minio https://charts.min.io/
helm repo update
helm install minio --version 5.0.3 --namespace bigdata -f values.yaml minio/minio