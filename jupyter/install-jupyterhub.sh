#!/bin/bash

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/

helm upgrade --install jupyterhub jupyterhub/jupyterhub -f values.yaml --namespace bigdata