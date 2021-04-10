# sumologic

Extract non json logs

```
_sourcecategory = "k8s-test"
| where namespace = "myapp"
| json "log"
| keyvalue auto field=log
```
