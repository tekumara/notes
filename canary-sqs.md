# canary sqs

you could have a feature flag which is evaluated each time you consume a message and decides for a percentage of them to process the message using the new version of your code.

If the change doesn’t warrant a feature flag, then you can do a canary deployment using the same tools as you would for an API deployment (like Argo Rollouts in Kubernetes) but the key difference is how you control the split of traffic between the canary and the current deployment.

For APIs, traffic distribution is typically handled by a load balancer (like nginx). The load balancer automatically routes a specified percentage of incoming requests to the canary version. For SQS consumers, there’s no load balancer - instead, message distribution depends on the number of consumer threads. You have to manage this via the number of replicas you deploy and the number of threads the application uses to consume from SQS.

For example, assume your current deployment has 2 replicas with 10 threads each, i.e.: 20 threads consuming from SQS.

You deploy a canary with 1 replica and 1 thread. This would consume 1/21 = ~5% of the messages being written to the queue.

After deploying the canary, you enter an analysis period where you monitor key metrics and behaviour of the new version. If it’s good, you proceed to roll it out as 2 replicas with 10 threads each. If it’s bad, you roll it back, i.e.: delete the canary deployment.
