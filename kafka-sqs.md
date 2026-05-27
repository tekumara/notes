# kafka -> sqs

Good if you need a DLQ, because you can redrive back to the SQS.

DLQ needed for poison messages if workload can vary based on message.

Also good for scaling, if you need more workers than partitions.
Or you want to change the granularity of scaling by writing a batch of Kafka messages to SQS as a single message.


