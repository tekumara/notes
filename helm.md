# helm 3

## Usage

`helm install` install a chart  
`helm upgrade --install` upgrade a release, or install if a release of this name doesn't exist  
`helm list` list current releases in the current namespace
`helm history slim-api` list the history of slim-api releases
`helm get all slim-api` describe all info for release slim-api
`helm uninstall slim-api` uninstall the release slim-api, and delete the release history
`helm rollback slim-api` rollback to previous release of slim-api
`helm repo list` list chart repos
`helm repo update` get lastest version of charts from repos
`helm show all $repo/$chart` inspect chart $chart from repo $repo
`helm template mychart --values values.yaml` produce a template
