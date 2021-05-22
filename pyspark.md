# pyspark

## Example

```python
from pyspark import SparkConf
from pyspark.sql import DataFrame, SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import IntegerType, StringType

dept = [("Finance",10),
        ("Marketing",20),
        ("Sales",30),
        ("IT",40)
      ]
deptColumns = ["dept_name","dept_id"]
df = spark.createDataFrame(data=dept, schema = deptColumns)
```

## Pyfiles

--py-files will distribute .py and .zip/.egg files to all executors. eg:

```
--py-files s3://todo-app/todo-common.zip,todomain.py
```

The py-files are downloaded into a /var directory on the driver and executors. This /var directory is added to PYTHONPATH and the non `.py` files are added directory to PYTHONPATH. eg:

```
>>> import sys; sys.path
['', '/private/var/folders/00/3ln54lf50bv0bhyp38nskdhr0000gn/T/spark-a9383a06-d58e-45ae-8c9b-c567db1a7249/userFiles-f29f8a1a-4e35-42a4-b567-678a7e522dbf/todo-common.zip', '/private/var/folders/00/3ln54lf50bv0bhyp38nskdhr0000gn/T/spark-a9383a06-d58e-45ae-8c9b-c567db1a7249/userFiles-f29f8a1a-4e35-42a4-b567-678a7e522dbf',

ls /private/var/folders/00/3ln54lf50bv0bhyp38nskdhr0000gn/T/spark-a9383a06-d58e-45ae-8c9b-c567db1a7249/userFiles-f29f8a1a-4e35-42a4-b567-678a7e522dbf/

todo-common.zip
todomain.py

```

## S3

To use S3A for S3 URLs and temporary AWS STS credentials:

```
pyspark --conf spark.hadoop.fs.s3.impl=org.apache.hadoop.fs.s3a.S3AFileSystem --conf spark.hadoop.fs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.TemporaryAWSCredentialsProvider
```

To modify an existing spark session to use S3A for S3 urls, for example `spark` in the pyspark shell:

```
spark.sparkContext._jsc.hadoopConfiguration().set("fs.s3.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
```

To test, try and load this public dataset inside pyspark:

```
df = spark.read.csv("s3://ebirdst-data/ebirdst_run_names.csv")
```

## Config file

[Spark configuration](https://spark.apache.org/docs/latest/configuration.html#dynamically-loading-spark-properties) values can be specified on the command line, when creating a SparkContext, or in _$SPARK_HOME/conf/spark-defaults.conf_.

Each line consists of a key and a value separated by whitespace, eg:

```
spark.hadoop.fs.s3.impl org.apache.hadoop.fs.s3a.S3AFileSystem
spark.hadoop.fs.s3a.aws.credentials.provider org.apache.hadoop.fs.s3a.TemporaryAWSCredentialsProvider
```

## SPARK_HOME

Spark expects to find binaries at _$SPARK_HOME/bin_ and configuration at _$SPARK_HOME/conf/spark-defaults.conf_.

SPARK*HOME will default to *$VIRTUAL*ENV/lib/python\*/site-packages/pyspark/* if not set.

## Errors

### java.net.BindException: Cannot assign requested address: Service 'sparkDriver' failed after 16 retries (on a random free port)!

Occurs when `getent hosts $(hostname)` returns nothing or a non-localhost address. Add an entry in`/etc/hosts/` pointing your hostname to 127.0.0.1 or set SPARK_LOCAL_IP, eg:

```
SPARK_LOCAL_IP=127.0.0.1 pyspark
```

Or set `spark.driver.host`:

``
SparkConf conf = new SparkConf().setMaster("local[*]").set("spark.driver.host", "localhost");

```

### Java gateway process exited before sending its port number

Check the `JAVA_HOME` environment variable is set correctly to JDK8.

## No module named pyspark.daemon

Make sure your spark application doesn't have a package called `pyspark` as it will override the pyspark packages.
```
