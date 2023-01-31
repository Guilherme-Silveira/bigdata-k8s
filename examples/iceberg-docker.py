from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

conf = SparkConf()

conf.setAppName("Spark minIO Test")
conf.set("spark.hadoop.fs.s3a.endpoint", "http://minio:9000")
conf.set("spark.hadoop.fs.s3a.access.key", "silveira")
conf.set("spark.hadoop.fs.s3a.secret.key", "guilherme@123")
conf.set("spark.hadoop.fs.s3a.path.style.access", True)
conf.set("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
conf.set('spark.hadoop.fs.s3a.aws.credentials.provider', 'org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider')
conf.set("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
conf.set("spark.sql.catalog.spark_catalog", "org.apache.iceberg.spark.SparkSessionCatalog") 
conf.set("hive.metastore.uris", "thrift://metastore:9083")
conf.set("spark.sql.catalog.spark_catalog.type", "hive")
conf.set("spark.sql.catalog.spark_catalog.uri", "thrift://metastore:9083")
conf.set("spark.sql.catalog.spark_catalog.s3.endpoint", "http://minio:9000")
conf.set("iceberg.engine.hive.enabled", "true")
conf.set("spark.sql.defaultCatalog", "spark_catalog")

spark = SparkSession.builder.config(conf=conf).enableHiveSupport().getOrCreate()