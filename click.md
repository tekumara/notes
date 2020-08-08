# Click

## Gotchas

* Click has `--help` but not `-h` by default like argparse but can be [customized per command](https://click.palletsprojects.com/en/7.x/documentation/#help-parameter-customization) or also [for a group](https://github.com/pallets/click/issues/75#issuecomment-481128649)
* Click how do you get the defaults in the help? Typer shows them by default.

## Example

Create a group called `main`:

```python
@click.group()
@click.option("--ssid", help="WiFi network name.")
@click.option("--security", type=click.Choice(["WEP", "WPA", ""]))
@click.option("--password", help="WiFi password.")
@click.pass_context
def main(ctx, ssid: str, security: str = "", password: str = ""):
    qr = wifi_qr(ssid=ssid, security=security, password=password)
    ctx.obj["qr"] = qr
```

Create child commands of the group `main` that receive the group's context:

```python
@main.command()
@click.pass_context
def terminal(ctx):
    """Print QR code to the terminal."""
    print(ctx.obj["qr"].terminal())
```

[ref](https://kite.com/blog/python/python-command-line-click-tutorial/)

## vs typer

Typer supports [help for CLI arguments](https://typer.tiangolo.com/tutorial/arguments/help/#help-text-for-cli-arguments-in-click)
Configuration is via defaults rather than decorators which is nicer because everything is together, but it means if you call a typer command function from another function the caller has to specify all values
