# Intellij pylint

* Install pylint into the system's python distribution.
* Settings - External tools - Add pylint:
  * Program: `env`
    * use `env` so we can set environment variables ([ref](https://youtrack.jetbrains.com/issue/IDEA-14429))
  * Parameters: `PYLINTRC=$ProjectFileDir$/.pylintrc PATH=$ProjectFileDir$/env/bin:$PATH pylint -f parseable $FilePath$`
    * uses `.pylintrc` in the project's directory. 
    * modifies the path so pylint can find packages installed into the virtualenv at `$ProjectFileDir$/env/`, which avoids "unable to import" errors. Also uses the version of pylint from the virtualenv
    * `-f parseable` includes the filename in the output for hyperlinking
  * Working directory: `/tmp`
    * needs to be something other than `$ProjectFileDir$` to generate a full path for the output filter ([ref](https://intellij-support.jetbrains.com/hc/en-us/community/posts/206327209-external-tool-output-filter-for-Google-Closure-Compiler))
  * Output Filters... Add
    * Name: `pylint`
    * Regular expression to match output: `$FILE_PATH$:$LINE$:` ([ref](https://www.jetbrains.com/help/idea/add-edit-filter-dialog-2.html))
* To add to the Main toolbar, right click on the Main toolbar - Customize Menus and Toolbars..

To run, select a file or directory in the Project viewer, then Tools - External Tools - pylint

[ref](https://kirankoduru.github.io/python/pylint-with-pycharm.html)

