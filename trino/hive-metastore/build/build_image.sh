#!/bin/bash

set -e

REPONAME=guisilveira
TAG=hive-metastore

docker build -t $TAG .

# Tag and push to the public docker repository.
docker tag $TAG $REPONAME/$TAG
docker push $REPONAME/$TAG


# Update configmaps
kubectl create configmap metastore-cfg --namespace bigdata --dry-run=client --from-file=metastore-site.xml --from-file=core-site.xml -o yaml | kubectl apply -f -
