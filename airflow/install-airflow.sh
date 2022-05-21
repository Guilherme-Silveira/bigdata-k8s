#!/bin/bash

helm repo add apache-airflow https://airflow.apache.org

helm upgrade --install airflow -f values.yaml apache-airflow/airflow --namespace bigdata

kubectl apply -f airflow-spark-permission.yaml