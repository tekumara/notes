# aws cloudtrail

CloudTrail event logs can be delayed up to 15 minutes per services. It is possible to see recent logs from one AWS service, but not another.

Show RunInstances events in the last 30 mins:

```
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=RunInstances --start-time "$(echo "($(date +%s)-(60*30))" | bc)" > /tmp/events
```

Parse events

```
jq -r '.Events[] | [.EventTime, .EventName, .Username] | @tsv' /tmp/events | column -t | less
```
