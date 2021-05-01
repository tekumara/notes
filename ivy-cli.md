# Ivy CLI

## Install

Ubuntu

```
sudo apt-get install ivy
alias ivy=`java -jar /usr/share/java/ivy-2.3.0.jar`
```

macOS:

```
brew install ivy
```

## Usage

Resolve

````
ivy -dependency org.apache.spark spark-core_2.12 3.0.1
```

Download an artifact and all its dependencies to _lib/_

```
ivy -dependency org.apache.hadoop hadoop-aws 2.8.1 -retrieve "lib/[artifact]-[revision](-[classifier]).[ext]"
```

[ref](https://stackoverflow.com/a/15456621/149412)
