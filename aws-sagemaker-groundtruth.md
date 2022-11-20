# AWS SageMaker Ground Truth

## Troubleshooting

> There was an issue with your input data setup. Ground Truth could not setup a connection with your dataset in S3. Please check your input data setup and try again, or use the manual data setup option. Network Failure Request id: 3e0036a0-a049-4ad0-b6fc-2a332d8a4f4d

When creating a labeling job and pressing the `Complete data setup` button this will occur if your role does not have [`groundtruthlabeling:RunGenerateManifestByCrawlingJob`](https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazongroundtruthlabeling.html)
