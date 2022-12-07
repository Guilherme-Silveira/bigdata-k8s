#!/bin/bash

helm repo add airbyte https://airbytehq.github.io/helm-charts
helm repo update
helm install --values ./values.yaml airbyte airbyte/airbyte --namespace bigdata