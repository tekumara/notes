# bash for loop

## Run multiple commands in the background

eg: run curl 10 times in background

```
for i in {1..10};  do curl http://localhost:8080/healthCheck &   done
```

## Loop/run repeatedly

```
for i in $(seq 1 24); do date +"%H:%M:%S"; ( doStuff & ); sleep 300; done
```

doStuff runs every 5 mins for 2 hours. doStuff is run in the background so that the sleep happens in parallel, and therefore doStuff is run exactly every 5 minutes regardless of how long it takes to run.

## Loop through strings

```
for element in a b c; do echo $element; done
```

## Loop through files

```
for file in *.esdocs.*; do echo "$file"; done
```

## Loop through array

```bash
array=(one two three)
for i in "${array[@]}"
do
   echo "$i"
done
```

Array elements can be on their own line.
