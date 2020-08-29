# spark build

To build Spark v2.4.4:

```
git checkout v2.4.4
./dev/make-distribution.sh --name custom-spark --pip --tgz -Phadoop-2.7 -Phive -Phive-thriftserver -Pmesos -Pyarn -Pkubernetes
```

Creates `spark-2.4.4-bin-custom-spark.tgz` that matches the distribution on the [Spark download page](https://spark.apache.org/downloads.html), but without R. The only difference will be cosmetic differences, eg: build username) in *MANIFEST.MF*, *LICENSE*, *spark-version-info.properties* files inside the spark jars.

`make-distribution.sh` will also produce a python source distribution at `python/dist/pyspark-2.4.4.tar.gz`. This is uploaded to [pypi](https://pypi.org/project/pyspark/#files) instead of a wheel, and contains the same set of jars as the Spark download page distribution.

`python setup.py sdist` in the *python/* dir will manually build the python source distribution  
`twine upload --repository testpypi dist/*` will manually upload the source dist  
`dev/run-pip-test` will `pip install python/dist/pyspark-2.4.4.tar.gz` and run some tests.

## Building with hadoop 3.1

Hive doesn't work with hadoop 3.1 so don't include it:

```
./dev/make-distribution.sh --name hadoop-3.1-cloud-no-hive --pip --tgz -Phadoop-3.1 -Phadoop-cloud -Pmesos -Pyarn -Pkubernetes

```

## Troubleshooting

```
[error] /Users/tekumara/code3/spark/common/unsafe/src/main/java/org/apache/spark/unsafe/Platform.java:25: error: cannot find symbol
```

Make sure you are using jdk8.

```
Could not import pypandoc - required to package PySpark
```

The other symptom is  `python/pyspark.egg-info/PKG-INFO` shows `!!!!! missing pandoc do not upload to PyPI !!!!`

Make sure you have pypandoc and pandoc installed.
