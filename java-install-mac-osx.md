# Java installation on Mac OS X

Mac OS X does not come installed with java. If you run `java` it will take you to the the latest Oracle Java SE download page.

## Installation via brew

Install specific version of EPL licensed [Temurin OpenJDK](https://github.com/Homebrew/homebrew-cask-versions/blob/master/Casks/temurin17.rb) (recommended):

```
brew install homebrew/cask-versions/temurin17
```

This will install the [Temurin OpenJDK .pkg file](https://github.com/adoptium/temurin17-binaries/releases) into _/Library/Java/JavaVirtualMachines/_. `java` is located at _/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home/bin_

Install specific version of GPL licensed [Oracle OpenJDK](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/openjdk@17.rb):

```
brew install openjdk@17
# For the system Java wrappers (see below) to find this JDK, symlink it with:
sudo ln -sfn $HOMEBREW_PREFIX/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
```

## Switching versions in the shell

Show java versions in `/Library/Java/JavaVirtualMachines/` and the preferred Java home directory:

```
/usr/libexec/java_home -V
```

eg:

```
Matching Java Virtual Machines (2):
    17.0.5 (arm64) "Eclipse Adoptium" - "OpenJDK 17.0.5" /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
    11.0.17 (arm64) "Eclipse Adoptium" - "OpenJDK 11.0.17" /Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
```

Preferred Java home version is _/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home_... which is not necessarily the same as the JAVA_HOME environment variable.

`which java` will point to `/System/Library/Frameworks/JavaVM.framework/Versions/Current/Commands/java` which selects the java version based on the `JAVA_HOME` environment variable. So to change the java version in the current shell, change `JAVA_HOME`, eg:

```
export JAVA_HOME=$(/usr/libexec/java_home -v 11); java -version
```

If `JAVA_HOME` is unset the latest version will be chosen.

Useful aliases:

```
alias jdk11='export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home'
alias jdk17='export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home'
```

## jenv

[jenv](https://github.com/jenv/jenv) provides shims that select the appropriate java version based on the context.

jenv doesn't install versions for you. Use brew to install a version then `jenv add` to make jenv aware of it.

Versions can be specific to the current shell only (`jenv shell`) or for a specific directory (`jenv local`).

Given macOS already has a shim (based on `JAVA_HOME`), automatically switching based on the current directory is probably the only real advantage of jenv. Or if you need a consistent ways across Linux & macOS to switch java versions.

## sdkman

[sdkman](https://github.com/sdkman/sdkman-cli) will install versions of java (and gradle and spark) as well as let you switch between them. However, installations are independent from brew.
