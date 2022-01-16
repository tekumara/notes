# ray

Auto-scaling ([unlike AWS Batch](https://raysummit.anyscale.com/content/Videos/nAcQJ2jkNGDjJ5smP))

## ray serve

Head node doesn't support HA yet.

## ray locally

```
pip install 'ray[default]'
ray start --head
```

Visit dashboard on [http://localhost:8265](http://localhost:8265)

## ray on kubes

```
git clone git@github.com:ray-project/ray.git
cd ray

helm -n ray install example-cluster --create-namespace deploy/charts/ray

# forward dashboard to http://localhost:8265
kubectl -n ray port-forward service/example-cluster-ray-head 8265:8265

# forward server to http://localhost:10001
kubectl -n ray port-forward service/example-cluster-ray-head 10001:10001 &

mkvenv
pip install ray
```

The helm chart installs the ray operator which creates a head node

