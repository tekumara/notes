# dynamodb

Describe table

```
aws dynamodb describe-table --table-name $(TABLE_NAME)
```

Describe table tags

```
aws dynamodb list-tags-of-resource --resource-arn arn:aws:dynamodb:$(REGION):$(ACCOUNT_ID):table/$(TABLE_NAME)
```

Describe autoscaling targets

```
aws application-autoscaling describe-scalable-targets --service-namespace dynamodb
```

Get item

```
aws dynamodb get-item --table-name dt-apps-terraform-lock --key '{"LockID":{"S":"delete-me"}}'
```

Get items

```
for i in 123 124; do aws dynamodb get-item --table-name encodings --key '{"Id-Type":{"S": "'"$i"'-metadata"}}' | jq -r '[.Item.Value.S|fromjson|.error,"'"$i"'"]|@tsv' ; done
```

Scan

```
aws dynamodb scan --table-name terraform-lock
```

Put item

```
aws dynamodb put-item --table-name dt-apps-terraform-lock --item '{"LockID":{"S":"delete-me"}, "list":{"L":[{"S":"Cookies"},{"S":  "Coffee"},{"N":"3.14159"}]}}'
```

## Streams

Like Kinesis streams, but has a slightly different API. One stream per DyanmoDb shard, so a small database will only have one stream. The shard has to be processed in order, so you want to make sure the Lambda reading from it is quick so the stream doesn't back up (check the iterator age). You also need to think about error handling - if you don't care about ordering you can dump errors in a dead letter queue and keep progressing. If you do, then you will want to retry forever, and in unrecoverable error cases, manually intervene to fix any errors before processing can continue.

## Indexes

## Secondary Indexes

"Every attribute in the index key schema must be a top-level attribute of type String, Number, or Binary." see [Improving Data Access with Secondary Indexes](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SecondaryIndexes.html)

## Sparse indexes

"For or any item in a table, DynamoDB writes a corresponding index entry only if the index sort key value is present in the item. " see [Take Advantage of Sparse Indexes](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-indexes-general-sparse-indexes.html)

See also
[Best Practices for Using Secondary Indexes in DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-indexes.html)

## Throughput

```
botocore.errorfactory.LimitExceededException: An error occurred (LimitExceededException) when calling the UpdateTable operation: Subscriber limit exceeded: Provisioned throughput decreases are limited within a given UTC day. After the first 4 decreases, each subsequent decrease in the same UTC day can be performed at most once every 3600 seconds. Number of decreases today: 5. Last decrease at Sunday, March 24, 2019 9:07:28 AM UTC. Next decrease can be made at Sunday, March 24, 2019 10:07:28 AM UTC
```

## Basic alarms

"'Basic CloudWatch Alarms' are created/updated when you create/update a DynamoDB Table via the AWS Console. More precisely, this/these RCU/WCU 'basic CloudWatch Alarm(s)' will be created/updated if auto scaling is disabled for the RCU/WCU of a DynamoDB Table when creating/updating it via the AWS Console. Additionally, this/these RCU/WCU 'basic Alarm(s)' will be deleted if auto scaling is enabled for the RCU/WCU of a DynamoDB Table when creating/updating it via the AWS Console. It is possible to control their creation as they are only created/updated when you interact with a DynamoDB Table using the AWS Console.

As a last note, if you are not using auto scaling and you are not interacting with DynamoDB using the AWS Console, I would recommend that you create CloudWatch Alarms on the `ConsumedReadCapacityUnits` and the `ConsumedWriteCapacityUnits` of your DynamoDB Tables. The actions of these Alarms could send messages to an SNS topic you have subscribed to. That would allow you to get notified and to react if the `ConsumedReadCapacityUnits`/`ConsumedWriteCapacityUnits` are respectively close to the `ProvisionedReadCapacityUnits`/`ProvisionedWriteCapacityUnits` of one of your DynamoDB Tables. "

## Logging

Log requests failures (eg: ProvisionedThroughputExceededException)

```
log4j.logger.com.amazonaws.request=DEBUG
```

eg:

```
2019-05-20T07:11:23Z    2019-05-20 07:11:23.458 <34c639ad-7774-5823-b0d1-6cf1226be118> <235.383339d> <main> DEBUG com.amazonaws.request:1696 - Received error response: com.amazonaws.services.dynamodbv2.model.ProvisionedThroughputExceededException: The level of configured provisioned throughput for the table was exceeded. Consider increasing your provisioning level with the UpdateTable API. (Service: AmazonDynamoDBv2; Status Code: 400; Error Code: ProvisionedThroughputExceededException; Request ID: 3FCV62VDASDU7I55O75IQL2LSNVV4KQNSO5AEMVJF66Q9ASUAAJG)
2019-05-20T07:11:23Z    2019-05-20 07:11:23.458 <34c639ad-7774-5823-b0d1-6cf1226be118> <235.383339d> <main> DEBUG com.amazonaws.request:1244 - Retrying Request: POST https://dynamodb.ap-southeast-2.amazonaws.com / Headers: (User-Agent: aws-sdk-java/1.11.526 Linux/4.14.106-92.87.amzn2.x86_64 OpenJDK_64-Bit_Server_VM/25.181-b13 java/1.8.0_181 scala/2.11.12 vendor/Oracle_Corporation exec-env/AWS_Lambda_java8 dynamodb-table-api/1.11.526, amz-sdk-invocation-id: c2c2c2b1-d901-2385-3152-310850f5ec41, Content-Length: 16527, X-Amz-Target: DynamoDB_20120810.PutItem, Content-Type: application/x-amz-json-1.0, )
```

Log retry attempts

```
log4j.logger.com.amazonaws.http.AmazonHttpClient=DEBUG
```

eg:

```
<main> DEBUG com.amazonaws.http.AmazonHttpClient:1748 - Retriable error detected, will retry in 6728ms, attempt number: 4
```

## Partitions

A dynamodb partition is 10GB (or 10 million items of 1 Kb). 1 partition supports 3000 RCU, or 1000 WCU.

## LSI

Has a 10/Gb limit of some sort.

LSI needs to be created at time of table creation.

GSI can be created anytime. Can be a lighter version (not all data). Requires an additional query to the GSI first.

Both have additional costs. You pay twice for the writes.

GSI is eventually consistent.

## On-demand

Can throttle, so pre-allocate nodes by setting up a provisioned table with the required capacity first, which creates the required number of nodes for your capacity, and then switch to on-demand.

## Auto-scaling

Rule of thumb: minimum capacity should be average capacity.
