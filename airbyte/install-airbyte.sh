#!/bin/bash

helm repo add airbyte https://airbytehq.github.io/helm-charts
helm repo update
helm install --version 0.43.6 --values ./values.yaml airbyte airbyte/airbyte --namespace bigdata