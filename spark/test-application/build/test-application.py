from pyspark.sql import SparkSession
from pyspark import SparkConf

conf = SparkConf()

conf.set("spark.hadoop.fs.s3a.endpoint", "http://minio-minio-storage:9000")
conf.set("spark.hadoop.fs.s3a.access.key", "silveira")
conf.set("spark.hadoop.fs.s3a.secret.key", "guilherme@123")
conf.set("spark.hadoop.fs.s3a.path.style.access", True)
conf.set("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
conf.set('spark.hadoop.fs.s3a.aws.credentials.provider', 'org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider')
conf.set("hive.metastore.uris", "thrift://hive:9083")
conf.setAppName("test-application")

spark = SparkSession.builder.config(conf=conf).enableHiveSupport().getOrCreate()

df = spark.read.table('bronze.titles')

df.write.saveAsTable('bronze.titles_spark') 
  