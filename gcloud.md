# gcloud

Location of settings:

```
gcloud info
```

Config:

```
gcloud config list
```

Set default project

```
gcloud config set project YOUR_PROJECT_ID
```

## GOOGLE_CLOUD_PROJECT

Google SDKs require a project to be specified for API calls. This can be set via the `GOOGLE_CLOUD_PROJECT` env var.

## Auth

### gcloud auth login

- Authenticates your user account for use with the gcloud CLI.
- Credentials are stored in _~/.config/gcloud/credentials.db_
- Does not provide credentials to client libraries or SDKs in your local code by default.

### gcloud auth application-default login

- Authenticates and creates an [Application Default Credentials](#application-default-credentials-adc) (ADC) file
- Stored in _~/.config/gcloud/application_default_credentials.json_
- For use by client libraries/SDKs

Does not have to be for the same project as `gcloud config set project` if the default project was changed after the ADC file was created.

For a specific project

```bash
gcloud auth application-default login --project=YOUR_PROJECT_ID
```

## Application Default Credentials (ADC)

Application Default Credentials are used by the [google-auth SDK](https://googleapis.dev/python/google-auth/latest/user-guide.html#application-default-credentials) when no explicit credentials are created by an application.

Application Default Credentials are established by the `GOOGLE_APPLICATION_CREDENTIALS` env var pointing at a JSON credential configuration file. Defaults to _~/.config/gcloud/application_default_credentials.json_. If not present the VM metadata server will be checked.

See [How Application Default Credentials works](https://cloud.google.com/docs/authentication/application-default-credentials).

## Python google-auth

Supports ADC. Credentials can also be created programmatically if your application needs to use multiple credentials or needs more control.

See [google-auth User Guide](https://googleapis.dev/python/google-auth/latest/user-guide.html).

## WIF

Provides a federated workload identity, identified by a [federated access token](https://cloud.google.com/docs/authentication/token-types#fed-access-tokens). Identities can be provided for AWS/Azure compute instances, Kubernetes, Github Actions and more.

Once identified your workload can access resources using:

- [direct access](https://cloud.google.com/iam/docs/workload-identity-federation) as your federated workload identity using resource-specific roles.
- service account impersonation - Instead of granting access to a workload directly, you grant access to a service account, then have the workload use the service account as its identity. Uses

Application Default Credentials (ADC) support WIF credential configuration files, see [create credential config for AWS or Azure](https://cloud.google.com/iam/docs/workload-identity-federation-with-other-clouds#create-cred-config).

For more info see

- [Configure Workload Identity Federation with AWS or Azure VMs](https://cloud.google.com/iam/docs/workload-identity-federation-with-other-clouds).
- [Configure Workload Identity Federation with Kubernetes](https://cloud.google.com/iam/docs/workload-identity-federation-with-kubernetes)
- [AIP-4117 External Account Credentials (Workload Identity Federation)](https://google.aip.dev/auth/4117).

### Service account impersonation

A user or federated workload identity can be used to impersonate a service account.

ADC can impersonate a service account when using a workload identity by specifying a service account email when creating the WIF credential configuration file. Alternatively, if for some reason you need more control, you can programmatically do the impersonation using the google auth SDK, see [Impersonated credentials](https://googleapis.dev/python/google-auth/latest/user-guide.html#impersonated-credentials).

Service account [access tokens are short-lived](https://cloud.google.com/iam/docs/service-account-creds) an expire after an hour by default. This can be configured. The google auth SDK provides a refresh method which google SDKs use to get a new token when needed (eg: [refreshing in the genai api client](https://github.com/googleapis/python-genai/blob/4113dcfbb21a9e9e1b35b20d1ba89e96a35ee6ac/google/genai/_api_client.py#L198)).

## Token types

See

- [All access tokens aren't created equal](https://jpassing.com/2023/01/24/all-google-access-tokens-are-not-created-equal/)
- [Token types](https://cloud.google.com/docs/authentication/token-types#access-tokens)

## Troubleshooting

### ValueError: Could not resolve project using application default credentials

Provide the project name or set the `GOOGLE_CLOUD_PROJECT` env var.

### Request is prohibited by organization's policy. vpcServiceControlsUniqueIdentifier

Your credentials don't have permissions. Check you are using the right creds, and they have access to the API you are trying to call.

eg:

```json
{
  "error": {
    "code": 403,
    "message": "Request is prohibited by organization's policy. vpcServiceControlsUniqueIdentifier: abcde12345",
    "status": "PERMISSION_DENIED",
    "details": [
      {
        "@type": "type.googleapis.com/google.rpc.PreconditionFailure",
        "violations": [
          {
            "type": "VPC_SERVICE_CONTROLS",
            "description": "abcde12345"
          }
        ]
      },
      {
        "@type": "type.googleapis.com/google.rpc.ErrorInfo",
        "reason": "SECURITY_POLICY_VIOLATED",
        "domain": "googleapis.com",
        "metadata": {
          "uid": "abcde12345",
          "service": "aiplatform.googleapis.com"
        }
      }
    ]
  }
}
```
