## Java Options

To use pyspark with temporary STS credentials

```
pyspark --driver-java-options "-Dspark.hadoop.fs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.TemporaryAWSCredentialsProvider"
```

To modify an existing session to use S3A for S3 urls:

```
spark.sparkContext._jsc.hadoopConfiguration().set("fs.s3.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
```

## Errors

### java.net.BindException: Cannot assign requested address: Service 'sparkDriver' failed after 16 retries (on a random free port)!

Occurs when `getent hosts `hostname`returns a network address. Add an entry in`/etc/hosts/` pointing your hostname to 127.0.0.1 or set SPARK_LOCAL_IP, eg:

```
SPARK_LOCAL_IP=127.0.0.1 pyspark
```

### Java gateway process exited before sending its port number

Check the `JAVA_HOME` environment variable is set correctly to JDK8.

### With S3A

With hadoop-aws v2.7.1 works.

```
pyspark --packages org.apache.hadoop:hadoop-aws:2.7.1
```

Unfortunately it will resolve the packages each time you run pyspark leading to a longer start up time.

Version 2.8.4 didn't work:

```
java.lang.IllegalAccessError: tried to access method org.apache.hadoop.metrics2.lib.MutableCounterLong.<init>(Lorg/apache/hadoop/metrics2/MetricsInfo;J)V from class org.apache.hadoop.fs.s3a.S3AInstrumentation
```

## No module named pyspark.daemon

Make sure your spark application doesn't have a package called `pyspark` as it will override the pyspark packages.

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
