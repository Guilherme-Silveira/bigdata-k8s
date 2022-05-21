#!/bin/bash

kubectl create secret generic my-s3-keys \
  --from-literal=access-key=silveira \
  --from-literal=secret-key='guilherme@123' \
  --namespace bigdata