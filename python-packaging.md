# Using a top level src directory

Generally a matter of [ease](http://as.ynchrono.us/2007/12/filesystem-structure-of-python-project_21.html) vs [correctness](https://hynek.me/articles/testing-packaging/#fn:disagreement).

[pytest recommends](https://docs.pytest.org/en/latest/goodpractices.html#choosing-a-test-layout-import-rules) using a `src/` so that tests are run against the installed version (which will test your packaging as well) rather than the contents of the repo's directory. This is also true of you application and is referred to as [import parity](https://blog.ionelmc.ro/2014/05/25/python-packaging/#the-structure).

But you may not need a src directory if you aren't producing a component to share widely, or with complex testing requirements, or if you want to test using the files in the local repo without installing first.

The [discussion](https://github.com/pypa/packaging.python.org/issues/320#issuecomment-390187657) [rages](https://github.com/pypa/packaging.python.org/issues/320#issuecomment-390213738) [on](https://github.com/pypa/packaging.python.org/issues/320#issuecomment-390336319).

[awscli](https://github.com/aws/aws-cli) doesn't use /src and [historically projects](https://github.com/pypa/packaging.python.org/issues/320#issuecomment-390188087) have been more inclined to not use /src
