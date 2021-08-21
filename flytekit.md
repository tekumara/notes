# flytekit

flytekit includes the follow python entrypoints:

- `flyte-cli` - deprecated general CLI, use flytectl instead
- `pyflyte` - compiles workflows and tasks, and docker image name, to protobuf
- `pyflyte-execute` - [executes python tasks](https://docs.flyte.org/projects/flytekit/en/latest/design/execution.html) on the cluster inside a container with the python code, marshalling inputs and outputs as protobuf/files/parquet.

See [Command Line Interfaces](https://docs.flyte.org/projects/flytekit/en/latest/design/clis.html#command-line-interfaces)

## debug task proto

```
$ flyte-cli parse-proto -f /tmp/0_myapp.workflows.example.say_hello_1.pb -p flyteidl.admin.task_pb2.TaskSpec
Config file not found at default location, relying on environment variables instead.
                        To setup your config file run 'flyte-cli setup-config'
Welcome to Flyte CLI! Version: 0.20.1
{
  "template": {
    "id": {
      "resourceType": "TASK",
      "project": "{{ registration.project }}",
      "domain": "{{ registration.domain }}",
      "name": "myapp.workflows.example.say_hello",
      "version": "{{ registration.version }}"
    },
    "type": "python-task",
    "metadata": {
      "runtime": {
        "type": "FLYTE_SDK",
        "version": "0.20.1",
        "flavor": "python"
      },
      "retries": {}
    },
    "interface": {
      "inputs": {},
      "outputs": {
        "variables": {
          "o0": {
            "type": {
              "simple": "STRING"
            },
            "description": "o0"
          }
        }
      }
    },
    "container": {
      "image": "myapp:v1",
      "args": [
        "pyflyte-execute",
        "--inputs",
        "{{.input}}",
        "--output-prefix",
        "{{.outputPrefix}}",
        "--raw-output-data-prefix",
        "{{.rawOutputDataPrefix}}",
        "--resolver",
        "flytekit.core.python_auto_container.default_task_resolver",
        "--",
        "task-module",
        "myapp.workflows.example",
        "task-name",
        "say_hello"
      ],
      "resources": {},
      "env": [
        {
          "key": "FLYTE_INTERNAL_IMAGE",
          "value": "myapp:v1"
        }
      ]
    }
  }
}
```

For workflows:
```
flyte-cli parse-proto -f /tmp/5_aircraft.02_etl_flow.main_2.pb -p flyteidl.admin.workflow_pb2.WorkflowSpec | less
```

## Troubleshooting

### ValueError: Type <class 'inspect.\_empty'> not supported currently in Flytekit. Please register a new transformer

Input params to a task need to be typed.

### AttributeError: type object 'OpenFlightsData' has no attribute '**annotations**'

OpenFlightsData is a `collections.namedtuple` instead of a `typing.NamedTuple`.

### TypeError: issubclass() arg 1 must be a class

Flyte does not support the Any type in a task signature. Convert it to a [supported type](https://docs.flyte.org/projects/cookbook/en/latest/auto/core/type_system/flyte_python_types.html).

### Transformer for type <class 'tuple'> is restricted currently

NamedTuples cannot be used as input types, see [#1337](https://github.com/flyteorg/flyte/issues/1337)

### ValueError: parquet must have string column names

Make sure your Dataframe has named columns, rather than the default which uses integers for column names.

### ValueError: DataFrames of type <class 'list'> are not supported currently

When using FlyteSchema, make sure to convert outputs to a DataFrame first.
