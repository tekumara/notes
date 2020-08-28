# python linting

pylint has the most checks, many of which are better turned off. The VS Code [default pylint rules](https://code.visualstudio.com/docs/python/linting#_default-pylint-rules) are reasonable.

[pycodestyle](https://github.com/PyCQA/pycodestyle) (formerly pep8) checks code against PEP8.
autopep8 requires pycodestyle and fixes issues it identifies.

[pyflakes](https://github.com/PyCQA/pyflakes) has fewer checks than pylint, and so is faster. It does not check style eg: PEP8.

[pylama](https://github.com/klen/pylama) bundles a lot of Python & JavaScript tools together.

[flake8](https://pypi.org/project/flake8/) is a wrapper around pyflakes, pycodestyle, and [McCabe complexity script](https://nedbatchelder.com/blog/200803/python_code_complexity_microtool.html). It supports additional addons.

[pyright](https://github.com/microsoft/pyright) is Microsoft's Python type checker running on node. It has active support and deployment, is fast, and in strict mode detects a lot of issues other type checkers miss.

[pylance](https://github.com/microsoft/pylance-release) is a VS Code language server extension that bundles pyright and other goodies like auto-imports, code completion and additional stubs (eg: pandas, matplotlib)

## Comparative analysis

| error                                                        | pylint\* | flake8 | pyright | pylance |
| ------------------------------------------------------------ | -------- | ------ | ------- | ------- |
| no-value-for-parameter                                       | ✔        | ✘      | ✘       | ✘       |
| too-many-function-args                                       | ✔        | ✘      | ✔       | ✔       |
| unused-import ([F401][f401])                                 | ✔        | ✔      | ✘       | ✘       |
| unused-argument                                              | ✔        | ✘      | ✘       | ✔       |
| not in ([E713][e713]) (pep8)                                 | ✘        | ✔      | ✘       | ✘       |
| undefined-variable                                           | ✔        | ½      | ✔       | ✔       |
| f-string without any placeholders ([F541][f541])             | ✘        | ✔      | ✘       | ✘       |
| module level import not at top of file ([E402][e402]) (pep8) | ✘        | ✔      | ✘       | ✘       |
| trailing whitespace ([W291][w291])                           | ✘        | ✔      | ✘       | ✘       |
| ambiguous variable name ([E741][e741]) (pep8)                | ✘        | ✔      | ✘       | ✘       |
| missing whitespace after ',' ([E231][e231])                  | ✘        | ✔      | ✘       | ✘       |
| too many leading '#' for block comment ([E266][e266]) (pep8) | ✘        | ✔      | ✘       | ✘       |
| not accessed                                                 | ✘        | ✘      | ✘       | ✔       |
| from module import \* ([F403][f403])                         | ✘        | ✔      | ✘       | ✘       |
| non-default argument follows default argument ([E999][e999]) | ✔        | ✔      | ✔       | ✔       |

\* _pylint using the VS Code [default pylint rules](https://code.visualstudio.com/docs/python/linting#_default-pylint-rules)_

pylint has syntax-error and flake8 has E999 but they capture different errors. pyright captures the superset.

[e713]: https://www.flake8rules.com/rules/E713.html
[f541]: https://flake8.pycqa.org/en/latest/user/error-codes.html
[e402]: https://www.flake8rules.com/rules/E402.html
[w291]: https://www.flake8rules.com/rules/W291.html
[e741]: https://www.flake8rules.com/rules/E741.html
[e231]: https://www.flake8rules.com/rules/E231.html
[f403]: https://www.flake8rules.com/rules/F403.html
[f401]: https://www.flake8rules.com/rules/F401.html
[e266]: https://www.flake8rules.com/rules/E266.html
[e999]: https://www.flake8rules.com/rules/E999.html

## References

- [Pylint checks](http://pylint.pycqa.org/en/latest/technical_reference/features.html)
- [Flake8 rules](https://www.flake8rules.com/) - detailed, but incomplete, see also [error codes](https://flake8.pycqa.org/en/latest/user/error-codes.html)
