# AWS EMR Notebooks

AWS EMR notebooks run on a t3.small instance in AWS managed account (244647660906) with an ENI that attaches the instance to your VPC.

The EMR notebook environment has [sparkmagic](https://github.com/jupyter-incubator/sparkmagic) which is used to access your EMR cluster via Livy. 

## Jobs dies after 60 mins

The default Livy session timeout is 60 mins. If your job dies at 60 mins, without any Spark executor failures, then increase the timeout, eg:
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

