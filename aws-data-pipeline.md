# aws data pipeline

DMS is particularly well suited for ongoing syncing. It can do also full loads of a table, but I don't know how to make it select a single column, and it may create multiple CSV objects.

Data pipeline and Glue both orchestrate the creation of compute, and use that to run a script that read & writes data. In Glue the compute is serverless and the scripts are python/scala and use Spark. Glue is well suited if you want to work with parquet, or know Spark.

With Data pipeline the scripts run on EC2 (or EMR steps). The scripts can be any shell command, or a CopyActivity that writes to a single CSV object and reads from a SqlDataNode that selects a single column.

Your pipeline will require an IAM role, as will the EC2 instance the activity runs on. If you don't have these IAM roles, and you already have compute that can access your database and S3 bucket, it may be easier just to write your own script/program in your language of choice and run it manually for a once-off migration.
