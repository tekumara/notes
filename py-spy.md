# py-spy

Dump thread stack trace for pytest:

```sh
sudo env PATH="$PATH" py-spy dump --pid $(pgrep -f bin/pytest)
```

Dump thread stack trace for test running in vscode:

```sh
sudo env PATH="$PATH" py-spy dump --pid $(pgrep -f run_pytest | tail -n1)
```
