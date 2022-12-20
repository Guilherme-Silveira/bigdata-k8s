#!/bin/bash

helm repo add superset https://apache.github.io/superset

helm upgrade --install --version 0.7.7 --values values.yaml superset superset/superset --namespace bigdata