# aws lambda

List functions in the account

```
aws lambda list-functions | jq -r '.Functions[].FunctionName'
```

[get-function](https://docs.aws.amazon.com/cli/latest/reference/lambda/get-function.html) returns the configuration information of the Lambda function and a pre-signed URL link to the .zip file:

```
aws lambda get-function --function-name <function-name>
```

Return a single configuration item (CodeSha256) as text:

```
aws lambda get-function --function-name <function-name> --query Configuration.CodeSha256 --output text
```

Get the lambda code

```
wget -O function.zip $(aws lambda get-function --function-name $FUNCTION_NAME --query 'Code.Location' --output text)
```

List all SQS, Kinesis, and DynamoDB stream mappings in the account

```
aws lambda list-event-source-mappings
```

List event source mappings for specific function

```
aws lambda list-event-source-mappings --function-name $function_name
```

List details of specific event source mapping

```
aws lambda get-event-source-mapping --uuid $uuid
```

Invoke and show logs

```
aws lambda invoke --invocation-type RequestResponse --function-name $(LambdaName) --payload '$(payload)' --cli-binary-format raw-in-base64-out --log-type Tail invoke.resp.payload | jq -r '.LogResult | @base64d'
```

List all lambdas

```
aws lambda list-functions | jq -r '.Functions[].FunctionName'
```

## Get a lamba's inline policy

Get the lambda's role:

```
aws lambda get-function --function-name myfunction --query Configuration.Role --output text

#arn:aws:iam::123456789012:role/my-LambdaRole-77MTY580HEW6
```

List role policies:

```
aws iam list-role-policies --role-name my-LambdaRole-77MTY580HEW6 --query PolicyNames --output text

#my-lambda-policy
```

Get specific policy:

```
aws iam get-role-policy --role-name my-LambdaRole-77MTY580HEW6 --policy-name my-lambda-policy
```

## [AWS Lambda Function Versioning and Aliases](https://docs.aws.amazon.com/lambda/latest/dg/versioning-aliases.html)

## Updating a lambda's code via CloudFormation

If you upload a new version of a lambda's code to S3, and update the `AWS::Lambda::Function` resource, but don't change `S3Bucket`, `S3Key`, or `S3ObjectVersion` in the `Code` property of the resource, the lambda function won't use the new version.
See the Note on [CloudFormation AWS Lambda Function Code](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-function-code.html)

## Invoke

The set of [response codes](https://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_ResponseSyntax) from an lambda invocation are determined by lambda, not your function.

`200` means the lambda was invoked with the `RequestResponse` invocation type.
If the lambda completes successfully it will return its response with a 200. Unhandled exceptions will also return a 200 response, but with

```
{
    "StatusCode": 200,
    "FunctionError": "Unhandled",
    "ExecutedVersion": "$LATEST"
}
```

and the JSON payload/output will contain more details, eg:

```
{"errorMessage":"key not found: classifiers","errorType":"java.util.NoSuchElementException","stackTrace":["scala.collection.MapLike$class.default(MapLike.scala:228)","scala.collection.AbstractMap.default(Map.scala:59)","scala.collection.MapLike$class.apply(MapLike.scala:141)","scala.collection.AbstractMap.apply(Map.scala:59)",...,"java.lang.reflect.Method.invoke(Method.java:498)"]}%
```

429 the Lambda has reached its concurrency limits, and is is being throttled (see the Lambda Throttles Cloudwatch metric).

When invoked with the `Event` invocation type, the response in all cases will only be:

```
{
    "StatusCode": 202
}
```

If the invocation fails, it will be tried again a minute later, and a final time 1:45 mins later. All invocations will have the same AWSRequestId.

## DLQ

Only ever used if Lambda is invoked asynchronously.

## Run-time environment

When a Lambda invocation finishes (either successfully or when an exception is thrown) the [Lambda execution context](https://docs.aws.amazon.com/lambda/latest/dg/running-lambda-code.html) is frozen (ie: cpu is no longer allocated to the container) - see [The Freeze/Thaw Cycle](https://aws.amazon.com/blogs/compute/container-reuse-in-lambda/). Thus, when the Java main thread running the handler function finishes, the other threads are frozen. They will resume their operations in subsequent invocations executed on the same container. However, there is no way to control whether that container will ever be used in any subsequent invocations or just destroyed.

When a Lambda invocation times out then the JVM is terminated, but its container is not. That container may receive subsequent invocations, and if and when it does, it will start the JVM again. The file system (eg: `/tmp`) will remain as is between invocations, as will the log stream name.

If you deliberately exit the JVM, eg: `System.exit(1)` it will be restarted when/if the container receives a subsequent invocation. You will see `Process exited before completing request` in the logs.

## Policy

To see who has been granted access to invoke the lambda:

```
aws lambda get-policy --function-name $FUNCTION_NAME | jq -r .Policy | jq .
```

## Handler functions (java)

You can either create your [own handler function](https://docs.aws.amazon.com/lambda/latest/dg/java-programming-model-handler-types.html) that takes input and optionally context. If you do so, the function itself must be referenced when creating the lamdbda, eg: `org.me.MyLambda::handlerFunction`. Or you can [implement the lambda request interface](https://docs.aws.amazon.com/lambda/latest/dg/java-handler-using-predefined-interfaces.html) and just specify the class when creating the lambda, eg: `org.me.MyLambda`.

Handler functions can take as input either primitives, POJOs or an `InputStream`. Primitives and POJOs will be deserialized by the lambda runtime using Jackson. If your handler specifies a input type that it doesn't receive, eg: a `String` but it receives a JSON object, then Jackson will through an exception. If you specify `Any` (scala) or `Object` (java) then any value JSON (eg: number, string, array, object) will be serialized into the appropriate Java type, eg: if its a JSON object, Jackson will pass a `j.u.LinkedHashMap` to your function. If you want to do the deserialization yourself, then use `InputStream` for the input type and pass it to your JSON decoder, see [this example](https://docs.aws.amazon.com/lambda/latest/dg/java-handler-io-type-stream.html.

The lambda runtime expects deployment packages to be laid out with classes in the root, and jars in `lib/` dir, see [Creating a ZIP Deployment Package for a Java Function](https://docs.aws.amazon.com/lambda/latest/dg/create-deployment-pkg-zip-java.html)

## Sizing

If you give your instance too little memory, it will receive too little CPU, and won't be able to do much. For example, a 128MB java lambda will timeout within 10 secs just throwing an exception!

## Metrics

[Invocations](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-functions-metrics.html) = 1 everytime lambda is invoked. Max, min and avg will always be 1. Sum and sample count are the only metrics that make sense, and will be the same value.

ConcurrentExecutions - Max will show the the highest concurrency reached during the time period. This is the number of lambda functions alive and processing requests. For non-poll based sources, this can be estimated using Little's Law, ie: invocations per second \* average execution duration in seconds, see [Understanding Scaling Behavior](https://docs.aws.amazon.com/lambda/latest/dg/scaling.html). When duration spikes (eg: due to cold starts) concurrent executions will increase as traffic continues to arrive and so new lambdas are scaled up.

## SQS Trigger

https://dzone.com/articles/amazon-sqs-as-an-event-source-to-aws-lambda-a-deep

When triggering Lambda from a SNS topic and the Lambda fails 3 times the SNS message ends up in the dead letter queue with the following message attributes:

ErrorMessage
RequestID
ErrorCode

These are very useful for debugging.

When using an SQS trigger, failing Lambda invocations also send the input message to the dead letter queue (as per the redrive policy) but without any message attributes.
It would be very helpful if the same message attributes are recorded with failures from Lambda invocations triggered by SQS.

## Retries

See [persistence](https://www.youtube.com/watch?v=d9Jb1WKCLd8&t=35m) and [retries](https://www.youtube.com/watch?v=d9Jb1WKCLd8&t=40m46s)

Persistence

Service
Persistence of requests "in flight"
| Lambda API | No formal persistence model |
| SNS | No formal persistence model beyond delivery retry logic that extends up through potentially 23 days when sending to Lambda and SQS |
| EventBridge | No formal persistence model beyond delivery retry logic that extends up through potentially 24 hours |
|SQS |By default messages are stored for 4 days. This can be modified to as little as 60 sgpseconds up to 14 days by configuring a queue's MessageRetentionPeriod attribute |

Retries

Lambda API
Retry/failure logic is client dependent for synchronous invocations. For asynchronous, invocations are retried twice by Lambda service (now configurable between zero and two with maximum event age 60 seconds - 6 hours).
SNS
If Lambda is not available, SNS will retry 3 times without delay, 2 times at 1 seconds apart, then 10 times with exponential backoff from 1 second to 20 seconds, and finally 100,000 times every 20 seconds for a total 100,015 attempts over more than 23 days before the message is discarded from SNS.
