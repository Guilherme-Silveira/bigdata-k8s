from datetime import datetime, timedelta
from os import getenv
from airflow.models import DAG
from airflow.providers.cncf.kubernetes.operators.spark_kubernetes import SparkKubernetesOperator
from airflow.providers.cncf.kubernetes.sensors.spark_kubernetes import SparkKubernetesSensor


default_args = {
  'owner': 'Guilherme da Silveira Souto Souza',
  'depends_on_post': False,
  'email': ['guilhermesilveira.s@hotmail.com'],
  'email_on_failure': False,
  'email_on_retry': False,
  'retries': 1,
  'retry_delay': timedelta(minutes=5)
}

dag = DAG(
  'test-spark-pipeline',
  default_args=default_args,
  start_date=datetime.now(),
  schedule_interval='@weekly',
  tags=['test', 'development', 'bash']
)

test_application_spark = SparkKubernetesOperator(
  task_id ='test_application_spark',
  namespace ='bigdata',
  application_file='manifests/test-application.yaml',
  kubernetes_conn_id='k3d',
  do_xcom_push=True,
  dag=dag
)

monitor_spark_app_status = SparkKubernetesSensor(
  task_id='monitor_spark_app_status',
  namespace='bigdata',
  application_name="{{ task_instance.xcom_pull(task_ids='test_application_spark')['metadata']['name'] }}",
  kubernetes_conn_id='k3d',
  dag=dag
)

test_application_spark >> monitor_spark_app_status
