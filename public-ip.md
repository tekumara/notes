# public ip

```
for i in $(seq 10);  do printf "%s\n" $(curl -fSs https://ifconfig.me/) ;  done
```
