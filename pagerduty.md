# PagerDuty

## Restricting shifts to specific hours

See [Scheduling Gaps](https://support.pagerduty.com/docs/schedules#section-scheduling-gaps) however, we during the gaps when no responder is on call incidents will not be triggered.

One option is to use the [Defined Support Hours](https://support.pageraduty.com/docs/dynamic-notifications#section-defined-support-hours) configuration. Incidents will always trigger but their urgency will be determined by the time of day, and users can adjust their low urgency notifications to be non intrusive. See also https://support.pagerduty.com/docs/service-settings#section-use-case-2-support-hours

## Low vs High Urgency

The responder notification setting determines urgency, and can be [configured on the service](https://support.pagerduty.com/docs/service-settings#section-step-1-configure-service):

- Notify responders until someone responds, escalate as needed (use high-urgency notification rules)
- Notify responders, do not escalate (use low-urgency notification rules) see [Configurable Service Settings](https://support.pagerduty.com/docs/service-settings)

Alternatively [Dynamic Notifications](https://support.pagerduty.com/v1/docs/dynamic-notifications) can be used to set urgency as set by the trigger, or via event rules.

[User profiles](https://support.pagerduty.com/docs/service-settings#section-step-2-configure-user-profiles) can be configured to handle the different levels of urgency differently.

## Disable/suppression

Disabling a service means it doesn't create any alerts or incidents.

Suppressing an event means it won't create an incident (or send emails/slack message) but it will still appear under [alerts](https://seek-jobs.pagerduty.com/alerts).
To suppress all events, create an Event Rule 'Summary exists' performs 'Suppress'

## CET

You can use ES6 syntax (eg: string interpolation)

`client_url` - provides a link on the event that you can use to take you to the source of the issue  
`client` - used for the link text, eg: "View in client"

## Testing an integration

Eg: sending an SNS notification for an EMR step failure CloudWatch rule

```
curl -XPOST -H'Content-Type: text/plain; charset=UTF-8' 'https://events.pagerduty.com/integration/$GUID/enqueue' -d '{
  "Type" : "Notification",
  "MessageId" : "46909041-8922-5159-8db6-c47a76b8c262",
  "TopicArn" : "arn:aws:sns:ap-southeast-2:123456789012:awesome-pipeline-monitoring",
  "Message" : "{\"version\":\"0\",\"id\":\"ac361b35-5558-c80f-d6cd-ec0f9764fb76\",\"detail-type\":\"EMR Cluster State Change\",\"source\":\"aws.emr\",\"account\":\"123456789012\",\"time\":\"2018-10-13T14:12:41Z\",\"region\":\"ap-southeast-2\",\"resources\":[],\"detail\":{\"severity\":\"CRITICAL\",\"stateChangeReason\":\"{\\\"code\\\":\\\"STEP_FAILURE\\\",\\\"message\\\":\\\"Shut down as step failed\\\"}\",\"name\":\"Manual run 20181011\",\"clusterId\":\"j-1Y4W9F10RFJO6\",\"state\":\"TERMINATED_WITH_ERRORS\",\"message\":\"Amazon EMR Cluster j-1Y4W9F10RFJO6 (Manual run 20181011) has terminated with errors at 2018-10-13 14:12 UTC with a reason of STEP_FAILURE.\"}}",
  "Timestamp" : "2018-10-13T14:12:42.651Z",
  "SignatureVersion" : "1",
  "Signature" : "M3s7qqQfX4u08swd5SIHNIGOFpbyAmrU6Bmztg6ZLFqU7VZ0VzEAqCmF0cAnITOSDwYLTpzH8wZfdiYxcGGQnf0oltgWRy0CG/i1Z1/J7CWjcGpuyylKTaTod4K+pnCuXVYMB25epm2SDnP4lAP491zJr2OmHD54a8MSYc4io4MabCt3R14rt3KQGyNr4MeGGbGsj1u9it3Exyf5Zdcc9XNjZbQuEbe1F/9do/YJfXMXdYzaeIuxUKzoBNi9TeBN18xoTjlx6Kw4cTltxPo0rtstcAMcBdxl4em5KVwXRO34Hb7dI7URoZtQHRqul7mOUtxov8B+V8q+LDa19IeoZg==",
  "SigningCertURL" : "https://sns.ap-southeast-2.amazonaws.com/SimpleNotificationService-ac565b8b1a6c5d002d285f9598aa1d9b.pem",
  "UnsubscribeURL" : "https://sns.ap-southeast-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:ap-southeast-2:123456789012:awesome-pipeline-monitoring:76bb8fc8-c990-44d6-839a-6321adf7c53d"
}'
```

eg: sending an SNS subscription confirmation

```
curl -XPOST -H'Content-Type: text/plain; charset=UTF-8' 'https://events.pagerduty.com/integration/$GUID/enqueue' -d '{
  "Type" : "SubscriptionConfirmation",
  "MessageId" : "05f1d07e-e5eb-4c18-a725-084892cb8eac",
  "Token" : "2336412f37fb687f5d51e6e241da92fcfcd43a5b5876113c30cdae39e4f289aa9cbe39e0a92fe752d6a1f7497d7e7b178c60527899dcb2346d5d83f294219a518a2d456a0f888fec12f059508c804058ea36570177cd833aec8d033b810c315e4ca2d37184e358a6c47112502ba468b5428ffdb454005e5b6590e457fc37464b",
  "TopicArn" : "arn:aws:sns:ap-southeast-2:123456789012:awesome-pipeline-monitoring",
  "Message" : "You have chosen to subscribe to the topic arn:aws:sns:ap-southeast-2:123456789012:awesome-pipeline-monitoring.\nTo confirm the subscription, visit the SubscribeURL included in this message.",
  "SubscribeURL" : "https://sns.ap-southeast-2.amazonaws.com/?Action=ConfirmSubscription&TopicArn=arn:aws:sns:ap-southeast-2:123456789012:awesome-pipeline-monitoring&Token=2336412f37fb687f5d51e6e241da92fcfcd43a5b5876113c30cdae39e4f289aa9cbe39e0a92fe752d6a1f7497d7e7b178c60527899dcb2346d5d83f294219a518a2d456a0f888fec12f059508c804058ea36570177cd833aec8d033b810c315e4ca2d37184e358a6c47112502ba468b5428ffdb454005e5b6590e457fc37464b",
  "Timestamp" : "2018-10-14T02:05:40.962Z",
  "SignatureVersion" : "1",
  "Signature" : "odhCr1/+OQYS6htCAxrvOlmDVhps6IXmawx83Jd0fV8DDBxtzzuAa61Ju19pk2KG4fNjSRJedrUGbVvudZIKB0+Kdzualt+E4Zbcqt5mQq40rtcYN85wxQ5xM68iG55g1ZpprdftbQ+NIxi2jP7SYY4SwaxPgZ6nSq7qUMDw2pwNvYhgwEx8Bt8bokhZKY+2C6yCi45ESHmb26C5eYsxbHCKCrNa/tBtNO0ai4v8iXDiKJX7IdKRZ6hYATDd+n9H5SYi57z7LX1EWLJNGPOUurd+XHmmCZr+jKQn2DtpW7XhxxZcFOxg3gLB3Q9EXQiHHFy2BoMCNXTXC7Dk2xgWzQ==",
  "SigningCertURL" : "https://sns.ap-southeast-2.amazonaws.com/SimpleNotificationService-ac565b8b1a6c5d002d285f9598aa1d9b.pem"
}'
```
