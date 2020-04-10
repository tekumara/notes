# AWS EMR Notebooks

AWS EMR notebooks run on a t3.small instance in an AWS managed account (244647660906) with an ENI that attaches the instance to your VPC. The instance does not have access to the internet.

The EMR notebook environment has [sparkmagic](https://github.com/jupyter-incubator/sparkmagic) which is used to access your EMR cluster via Livy. Livy runs on the EMR master node and starts the Spark driver in process. Livy's REST API runs on port 18888.

The [Spark Job monitoring widget](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-notebooks-spark-monitor.html#emr-managed-notebooks-monitoring-widget) is installed. The widget fetches and displays Spark job progress from the [Spark Monitoring REST API](https://spark.apache.org/docs/1.6.2/monitoring.html#rest-api). Its python package name is _awseditorssparkmonitoringwidget_.

The contents of _/home/notebook/work/_ is continually synced to S3. This is performed by the python package _awseditorsstorage_ which is a S3 backed ContentsManager for Jupyter built by AWS. It works in combination with a HTTP service running on localhost called _managed-workspace_.

The [jupyterlab-git](https://github.com/jupyterlab/jupyterlab-git) extension is also installed.

## PySpark kernel

The PySpark kernel is running on the master (inside the Livy process?)

On the first execution of any cell a Spark session will be started by Livy and the sparkmagic info widget displayed. The widget contains links to the Spark UI and Driver logs. These links require network level access to the cluster.

The `spark` variable contains the spark session. Example of loading a dataset:
```
df = spark.read.csv("s3://ebirdst-data/ebirdst_run_names.csv")
```

To see all Livy sessions:
```
%%info
```

To see Livy logs:
```
%%logs
```

## Logs are stored in S3

EMR stores all cluster logs at the _Log URI_ specified when a cluster is created. Both the _Log URI_ and the _Cluster ID_ are visible from the EMR cluster **Summary** tab.

The Livy/Spark driver logs are written to `livy-livy-server.out.gz` which is persisted to `"${LOG_URI}/${CLUSTER_ID}/node/${MASTER_INSTANCE_ID}/applications/livy/livy-livy-server.out.gz"` 

## Jobs die at the 60 minute mark

The default Livy session timeout is 60 mins. If your job dies at 60 mins, and because of an Spark executor failure, then it's probably Livy timing out the session. To increase the timeout, use this EMR configuration:
```
[
    {
        "Classification": "livy-conf",
        "Properties": {
            "livy.server.session.timeout-check": "true",
            "livy.server.session.timeout": "8h",
            "livy.server.yarn.app-lookup-timeout": "120s"
        }
    }
]
```
[ref](https://aws.amazon.com/premiumsupport/knowledge-center/emr-session-not-found-http-request-error/)

