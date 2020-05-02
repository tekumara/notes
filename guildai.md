# Guild AI

Guild is designed like a package manager & task runner (eg: the npm of ML) with experiment tracking/diffing/compare. Task running is a simple sequential execution of steps, rather than a complex DAG or parallel processing.

Takes a functional approach rather than OO ie: instead of making everything subclass a `GuildModel`, small pieces can be composed together in a .yml file.

Would be cool to automatically schedule a guild.yml in a scheduler like kubeflow/airflow/prefect. Guild becomes the nice interface/abstraction to these other (more complex) tools.

Guild stores a source code snapshot under the runs directory, eg: `.guild/runs/c46af199a57f4aae9bcc5635561b6391/.guild/sourcecode/`

Recording runs acts like a regression test for any refactoring.

## guild.yml

* `requires` can pass files between operations ([example](https://github.com/guildai/guildai/tree/master/examples/hello))
* `flags-import` can overwrite global variables, or command lines args, with config ([example](https://github.com/guildai/guildai/tree/master/examples/hello))

## Guild home

guild home:
* when inside a virtualenv is stored in the venv root, eg: `~/.virtualenvs/my-venv/.guild/`
* when not inside a virtualenv is stored in `~/.guild/`
* can be overridden by setting the environment variable `$GUILD_HOME`

## Usage

`guild ls 1` list files stored for run 1
`guild ops` lists the operations in `guild.yml`, or if there's no `guild.yml` in the current directory it shows operations from installed packages

## Scalars

Scalars are numeric metrics (eg: loss, accuracy) logged during a run and stored as tf events. Scalars can be:
* logged indirectly by your training framework to tf events, usually with a callback
* logged directly from your code [using tensorboardX directly](https://github.com/guildai/guildai/blob/18948a3008dfda5e638651f0e2466ee05bf09a64/examples/scalars/train_with_tensorboardX.py)
* captured from stdout by guildai and stored as tf events, aka [Output scalars](https://www-pre.guild.ai/scalars/). These are defined by regex patterns. The default pattern is `NAME: FLOAT` or you can [define your own patterns](https://github.com/guildai/guildai/tree/18948a3008dfda5e638651f0e2466ee05bf09a64/examples/scalars).

`guildai tensorboard` will start tensorboard and allow you to compare scalars across all the runs

## Labels

Labels can be applied to existing runs using `guild runs label`

## Web view

`guild view` starts a UI that visualises all runs and their output files, scalars and logs. Can also start tensorboard.

https://guild.ai/docs/tools/guild-view/

## Notebooks

Set a label
```
run.write_attr("label", "boom!!")
```

### Notebook Troubleshooting

tfevents files are not ending up in the runs directory (notebook)

guild.run will change the current directory to the run directory first, so make sure the tensorboard writer is instantiated in a function that called by guild.run() and not beforehand.

## Packages

Guild packages are wheels. Packages can have dataset dependencies (resources) that are downloaded when the operation that specifies them is run, and caches locally in `${GUILD_HOME}/cache/resources/`

`guild package` creates a wheel in `dist/` and can include output files from runs ([example](https://github.com/guildai/guildai/tree/master/examples/package))

`guild install gpkg.mnist` installed the [guild package mnist](https://github.com/guildai/packages/tree/master/gpkg/mnist) into the current virtualenv
