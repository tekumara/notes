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
`helm repo update` get latest version of charts from repos  
`helm show all $repo/$name` inspect chart $name from repo $repo  
`helm template mychart --values values.yaml` render chart  
`helm get all $release` describe all info (hooks, manifest, notes, values) for the release  
`helm get manifest $release` describe all resources for the release (does not include CRDs)  
`helm get manifest $release | yq '.' -o json allm | jq -r '"- \(.kind) \(.metadata.name)"'` describe all resources kinds and their name
`helm show crds $chart` describe all CRDs in the chart  
`helm get values slim-api -o yaml` get values yaml for latest revision  
`helm get values slim-api -o yaml --revision 156` get values yaml for revision 156  
`helm get values slim-api -o json | jq '.image.tag'` get image tag for latest revision  
`helm create $name` create a new helm chart in the dir _\$name_

## Troubleshooting

### unable to parse YAML: error converting YAML to JSON: yaml: line 24: found character that cannot start any token

Usually because the interpolation has failed. To see the yaml generated run: `helm template --debug test .` Remove lines that look suspicious. Make sure there aren't missing required values.

### no template "prefect-agent.fullname" associated with template "gotpl"

An include references a value that doesn't exist.

## UPGRADE FAILED has no deployed releases

Helm can't find any existing releases to upgrade. Make sure `helm upgrade --install` is being used. Check to see if there are any pending releases it tries to upgrade but can't find, eg: `helm ls -a` and uninstall them.
