# prefect

## Authentication

`prefect auth login` creates _~/.prefect/auth.toml_ and stores the API key there.

What I recommend doing though is using the environment variable `PREFECT__CLOUD__API_KEY`. Prefect will use this if it is set, rather than _auth.toml_.It avoids storing the key on disk and is more secure.

## Troubleshooting

### Found no flows

Flow objects must exist in the module namespace to be found. Flows that only have function-local references will not be found.  
