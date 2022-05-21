#!/bin/bash

helm repo add minio https://charts.min.io/
helm repo update
helm install minio --namespace bigdata -f values.yaml minio/minio