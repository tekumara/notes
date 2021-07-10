# kapp

- will show what changes that will be made to the cluster before they're executed
- waits until everything is running (no need to watch asynchronously)

`kapp deploy -a kpack -f release-0.0.4.yml`

## Failure logs

eg: when replicaset can't reach 4 replicas because of resource quotes:

```
11:09:37PM: ---- applying 1 changes [0/1 done] ----
11:09:39PM: create deployment/awesome-api (apps/v1) namespace: awesome
11:09:39PM: ---- waiting on 1 changes [0/1 done] ----
11:09:41PM: ongoing: reconcile deployment/awesome-api (apps/v1) namespace: awesome
11:09:41PM:  ^ Waiting for 4 unavailable replicas
11:09:41PM:  L ok: waiting on replicaset/awesome-api-848b7b75f5 (apps/v1) namespace: awesome
11:09:41PM:  L ongoing: waiting on pod/awesome-api-848b7b75f5-vzl9c (v1) namespace: awesome
11:09:41PM:     ^ Condition Ready is not True (False)
11:09:41PM:  L ongoing: waiting on pod/awesome-api-848b7b75f5-hwsr6 (v1) namespace: awesome
11:09:41PM:     ^ Condition Ready is not True (False)
11:09:41PM:  L ongoing: waiting on pod/awesome-api-848b7b75f5-gq569 (v1) namespace: awesome
11:09:41PM:     ^ Condition Ready is not True (False)
11:10:17PM: ongoing: reconcile deployment/awesome-api (apps/v1) namespace: awesome
11:10:17PM:  ^ Waiting for 3 unavailable replicas
11:10:17PM:  L ok: waiting on replicaset/awesome-api-848b7b75f5 (apps/v1) namespace: awesome
11:10:17PM:  L ongoing: waiting on pod/awesome-api-848b7b75f5-vzl9c (v1) namespace: awesome
11:10:17PM:     ^ Condition Ready is not True (False)
11:10:17PM:  L ok: waiting on pod/awesome-api-848b7b75f5-hwsr6 (v1) namespace: awesome
11:10:17PM:  L ok: waiting on pod/awesome-api-848b7b75f5-gq569 (v1) namespace: awesome
11:10:19PM: ongoing: reconcile deployment/awesome-api (apps/v1) namespace: awesome
11:10:19PM:  ^ Waiting for 2 unavailable replicas
11:10:19PM:  L ok: waiting on replicaset/awesome-api-848b7b75f5 (apps/v1) namespace: awesome
11:10:19PM:  L ok: waiting on pod/awesome-api-848b7b75f5-vzl9c (v1) namespace: awesome
11:10:19PM:  L ok: waiting on pod/awesome-api-848b7b75f5-hwsr6 (v1) namespace: awesome
11:10:19PM:  L ok: waiting on pod/awesome-api-848b7b75f5-gq569 (v1) namespace: awesome
11:10:22PM: ongoing: reconcile deployment/awesome-api (apps/v1) namespace: awesome
11:10:22PM:  ^ Waiting for 1 unavailable replicas
11:10:22PM:  L ok: waiting on replicaset/awesome-api-848b7b75f5 (apps/v1) namespace: awesome
11:10:22PM:  L ok: waiting on pod/awesome-api-848b7b75f5-vzl9c (v1) namespace: awesome
11:10:22PM:  L ok: waiting on pod/awesome-api-848b7b75f5-hwsr6 (v1) namespace: awesome
11:10:22PM:  L ok: waiting on pod/awesome-api-848b7b75f5-gq569 (v1) namespace: awesome
11:10:41PM: ---- waiting on 1 changes [0/1 done] ----
11:11:24PM: ongoing: reconcile deployment/awesome-api (apps/v1) namespace: awesome
11:11:24PM:  ^ Waiting for 1 unavailable replicas
11:11:24PM:  L ok: waiting on replicaset/awesome-api-848b7b75f5 (apps/v1) namespace: awesome
11:11:24PM:  L ok: waiting on pod/awesome-api-848b7b75f5-vzl9c (v1) namespace: awesome
11:11:24PM:  L ok: waiting on pod/awesome-api-848b7b75f5-hwsr6 (v1) namespace: awesome
11:11:24PM:  L ok: waiting on pod/awesome-api-848b7b75f5-gq569 (v1) namespace: awesome
```

Unfortunately it doesn't show the events, which indicate the root cause:

```
$ kubectl get events --sort-by='{.lastTimestamp}' | tail -n 1
11m         Warning   FailedCreate                      replicaset/awesome-api-848b7b75f5   (combined from similar events): Error creating: pods "awesome-api-848b7b75f5-q9bm7" is forbidden: exceeded quota: awesome, requested: limits.cpu=4,requests.cpu=4, used: limits.cpu=13250m,requests.cpu=12750m, limited: limits.cpu=16,requests.cpu=16
```

## field is immutable

```
10:25:22PM: ---- applying 2 changes [0/5 done] ----
10:25:22PM: update serviceaccount/awesome-api (v1) namespace: awesome
10:25:23PM: update poddisruptionbudget/awesome-api (policy/v1beta1) namespace: awesome
10:25:23PM: ---- waiting on 2 changes [0/5 done] ----
10:25:23PM: ok: reconcile poddisruptionbudget/awesome-api (policy/v1beta1) namespace: awesome
10:25:23PM: ok: reconcile serviceaccount/awesome-api (v1) namespace: awesome
10:25:23PM: ---- applying 3 changes [2/5 done] ----
10:25:23PM: update deployment/awesome-api (apps/v1) namespace: awesome

kapp: Error: Applying update deployment/awesome-api (apps/v1) namespace: awesome:
  Updating resource deployment/awesome-api (apps/v1) namespace: awesome:
    Deployment.apps "awesome-api" is invalid: spec.selector:
      Invalid value: v1.LabelSelector{MatchLabels:map[string]string{"app.kubernetes.io/instance":"awesome-api", "app.kubernetes.io/name":"generic-service", "kapp.k14s.io/app":"1607857863110332000"}, MatchExpressions:[]v1.LabelSelectorRequirement(nil)}: field is immutable (reason: Invalid)
```

See [Field is immutable error](https://github.com/vmware-tanzu/carvel-kapp/blob/0b705d6e41cfd6adb44060ff7c322113cf5496a5/docs/faq.md#-field-is-immutable-error):

Try:

```
kapp --apply-default-update-strategy fallback-on-replace
```
