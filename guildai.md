# Guild AI

Guild is designed like a package manager & task runner (eg: the npm of ML) with experiment tracking/diffing/compare. Task running is a simple sequential execution of steps, rather than a complex DAG or parallel processing.

Takes a functional approach rather than OO ie: instead of making everything subclass a `GuildModel`, small pieces can be composed together in a *guild.yml* file.

*guild.yml* could become the interface/abstraction between ML code and a scheduler. With the right integration tooling you could imagine a *guild.yml* being the interface to kubeflow pipeline/airflow DAG etc.

Guild is integrated with TensorBoard. It can read scalars from tfevent files, and launch TensorBoard.

Why record runs? Recording runs acts like a regression test for any refactoring.

Guild can:

* record metadata, eg: username, aws account, instance-type
* record model checkpoints
* record tensorboard training logs
* record tensorboard validation logs
* label experiments after the fact
* push experiments to model store
* pull experiments from model store
* store source code used during the experiment (not when using notebooks)
* watch the output of an experiment and sync it in real-time

Limitations:

* there isn't really a concept of namespaces for multiple models
* notebook support is limited. Guild's opinion is that training should be done in scripts via the CLI for better reproducibility.

## guild.yml

* `requires` can pass files between operations ([example](https://github.com/guildai/guildai/tree/master/examples/hello))
* `flags-import` can overwrite global variables, or command lines args, with config ([example](https://github.com/guildai/guildai/tree/master/examples/hello))

## Guild home

[guild home](https://guild.ai/docs/reference/guild-home/):

* when inside a virtualenv is stored in the venv root, eg: `~/.virtualenvs/my-venv/.guild/`
* when not inside a virtualenv is stored in `~/.guild/`
* can be overridden by setting the environment variable `$GUILD_HOME`

## Usage

* `guild ops` lists the operations in `guild.yml`, or if there's no `guild.yml` in the current directory it shows operations from installed packages
* `guild ls 1` list files stored for run 1
* `guild runs` show runs
* `guild push mstore 1` push run 1 to remote mstore
* `guild pull mstore` pull runs from remote mstore
* `guild view` starts a [UI](
https://guild.ai/docs/tools/guild-view/) that visualises all runs and their output files, scalars and logs. Can also start tensorboard.
* `guild label 1 --set worked!` change the label of run 1 to `worked!`

## Scalars

Scalars are numeric metrics (eg: loss, accuracy) logged during a run and stored as tf events. Scalars can be:

* logged indirectly by your training framework to tf events, usually with a callback
* logged directly from your code [using tensorboardX directly](https://github.com/guildai/guildai/blob/18948a3008dfda5e638651f0e2466ee05bf09a64/examples/scalars/train_with_tensorboardX.py)
* captured from stdout by guildai and stored as tf events, aka [Output scalars](https://www-pre.guild.ai/scalars/). These are defined by regex patterns. The default pattern is `NAME: FLOAT` or you can [define your own patterns](https://github.com/guildai/guildai/tree/18948a3008dfda5e638651f0e2466ee05bf09a64/examples/scalars).

`guildai tensorboard` will start tensorboard and allow you to compare scalars across all the runs

## Notebooks

Example of running in a notebook:

```python
# guildai will record function params as flags
def train(user="tekumara",
          aws_account = "my-research-account",
          instance_type = instance_type(),
          lr=0.00001, 
          weight_decay=0.000001):
    ...

    trainer = Trainer(
        ...
        # tensorboard logs will be written inside the run directory to logs/
        serialization_dir='./logs',
    )

    # alternatively, record the instance type as a file inside the run directory
    with open('instance-type', 'w') as f:
        f.write(instance_type())

    return trainer.train()

# start the training
# guild will create a new directory, and change into it
run, return_val = guild.run(train)
run
```

Set a label

```python
run.write_attr("label", "boom!!")
```

### Notebook Troubleshooting

If tfevents files are not ending up in the runs directory, make sure the tensorboard writer is instantiated in a function that called by `guild.run` and not beforehand.

## Source code tracking

Guild stores a source code snapshot under the runs directory, eg: *.guild/runs/c46af199a57f4aae9bcc5635561b6391/.guild/sourcecode/*  
However, this doesn't happen when running guild from a notebook.

## Packages

Guild packages are wheels. Packages can have dataset dependencies (resources) that are downloaded when the operation that specifies them is run, and cached locally in *${GUILD_HOME}/cache/resources/* 

`guild package` creates a wheel in *dist/* and can include output files from runs ([example](https://github.com/guildai/guildai/tree/master/examples/package))

`guild install gpkg.mnist` install the [guild package mnist](https://github.com/guildai/packages/tree/master/gpkg/mnist) into the current virtualenv