# python cli

## Completion

[argcomplete](https://argcomplete.readthedocs.io/en/latest/) - integrates with argparse, but runs the python script on tab completion so performance doesn't sound great

docopt [doesn't have support for completion](https://github.com/docopt/docopt/issues/261) out of the box, and requires a third party util

click has [support out of the box](https://click.palletsprojects.com/en/7.x/bashcomplete/#)

[plac](https://github.com/micheles/plac) doesn't have support for completion

docpie looks like it [has built in support](https://github.com/TylerTemp/docpie/blob/f9c909470b8e57e8b67d704ee15c7558ad8ab834/docpie/complete.py) for bash

## CLI libraries

plac - subcommands require writing a class or complex gymnastics

[argh](https://argh.readthedocs.io) - provides decorators for argpase, supports subcommands naturally

[typer](https://github.com/tiangolo/typer) - nice DSL based on type hints, based on click.

[click](https://github.com/pallets/click/issues/2164) - doesn't support defaults for multi-valued arguments (`nargs = *`), see [#2164](https://github.com/pallets/click/issues/2164)
