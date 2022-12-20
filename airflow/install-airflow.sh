#!/bin/bash

helm repo add apache-airflow https://airflow.apache.org

helm upgrade --install airflow -f values.yaml --version 1.7.0 apache-airflow/airflow --namespace bigdata

kubectl apply -f airflow-spark-permission.yaml