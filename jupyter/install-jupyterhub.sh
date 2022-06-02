#!/bin/bash

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/

kubectl apply -f jupyterhub-svc-sa.yaml

helm upgrade --install jupyterhub jupyterhub/jupyterhub -f values.yaml --namespace bigdata
