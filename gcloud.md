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

## Auth

### gcloud auth login

- Authenticates your user account for use with the gcloud CLI.
- Credentials are stored in _~/.config/gcloud/credentials.db_
- Does not provide credentials to client libraries or SDKs in your local code by default.

### gcloud auth application-default login

- Authenticates and creates an Application Default Credentials (ADC) file
- Stored in _~/.config/gcloud/application\_default\_credentials.json_
- For use by client libraries/SDKs

Does not have to be for the same project as `gcloud config set project` if the default project was changed after the ADC file was created.

For a specific project

```bash
gcloud auth application-default login --project=YOUR_PROJECT_ID
```

See [How Application Default Credentials works](https://cloud.google.com/docs/authentication/application-default-credentials)
