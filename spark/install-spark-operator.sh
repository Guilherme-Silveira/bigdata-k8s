#!/bin/bash

helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator

helm install spark spark-operator/spark-operator --namespace spark-operator --create-namespace