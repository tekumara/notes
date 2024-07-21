# py-spy

Dump thread stack trace for pytest:

```sh
sudo py-spy dump --pid $(pgrep -f bin/pytest)
```

Dump thread stack trace for test running in vscode:

```sh
sudo py-spy dump --pid $(pgrep -f run_pytest | tail -n1)
```
