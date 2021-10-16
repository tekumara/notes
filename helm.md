# helm 3

## Usage

`helm install` install a chart  
`helm upgrade --install` upgrade a release, or install if a release of this name doesn't exist  
`helm list` list current releases in the current namespace
`helm history slim-api` list the history of slim-api releases
`helm uninstall slim-api` uninstall the release slim-api, and delete the release history
`helm rollback slim-api --wait --debug` rollback to previous release of slim-api
`helm rollback slim-api 156 --wait --debug` rollback to revision 156 with debug
`helm repo list` list chart repos
`helm repo update` get lastest version of charts from repos
`helm show all $repo/$chart` inspect chart $chart from repo $repo
`helm template mychart --values values.yaml` produce a template
`helm get all slim-api` describe all info (hooks, manifest, notes, values) for release slim-api
`helm get values slim-api -o yaml` get values yaml for latest revision
`helm get values slim-api -o yaml --revision 156` get values yaml for revision 156
`helm get values slim-api -o json | jq '.image.tag'` get image tag for latest revision
