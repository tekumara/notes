# Java installation on Mac OS X

Mac OS X does not come installed with java. If you run `java` it will take you to the the latest Oracle Java SE download page.

## Installation via brew

Install specific version of [Oracle openjdk](https://github.com/Homebrew/homebrew-cask-versions/blob/master/Casks/java11.rb)
```
brew cask install java11
```

Install specific version of [AdoptOpenJDK](https://github.com/AdoptOpenJDK/homebrew-openjdk)
```
brew tap AdoptOpenJDK/openjdk
brew cask install adoptopenjdk11
```
This will install the [openjdk .pkg file](https://github.com/AdoptOpenJDK/openjdk11-binaries) into `/Library/Java/JavaVirtualMachines/`. `java` is located at `/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/bin/`

## Switching versions in the shell

Show java versions in `/Library/Java/JavaVirtualMachines/` and the preferred Java home directory which is the latest version:
```
/usr/libexec/java_home -V
```

eg:
```
Matching Java Virtual Machines (4):
    11.0.3, x86_64:	"AdoptOpenJDK 11"	/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home
    11.0.2, x86_64:	"OpenJDK 11.0.2"	/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home
    11.0.1, x86_64:	"OpenJDK 11.0.1"	/Library/Java/JavaVirtualMachines/openjdk-11.0.1.jdk/Contents/Home
    1.8.0_192, x86_64:	"Java SE 8"	/Library/Java/JavaVirtualMachines/jdk1.8.0_192.jdk/Contents/Home

/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home
```
Preferred Java home version is `/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home` .. which is not necessarily the same as the JAVA_HOME environment variable.

`which java` will point to `/System/Library/Frameworks/JavaVM.framework/Versions/Current/Commands/java` which selects the java version based on the `JAVA_HOME` environment variable. So to change the java version in the current shell, change `JAVA_HOME`, eg:

```
export JAVA_HOME=$(/usr/libexec/java_home -v 11); java -version
```

If `JAVA_HOME` is unset the latest version will be chosen.

Useful aliases:
```
alias jdk8='export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home'
alias jdk11='export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home'
```

## jenv

[jenv](https://github.com/jenv/jenv) provides shims that select the appropriate java version based on the context.

jenv doesn't install versions for you. Use brew to install a version then `jenv add` to make jenv aware of it.

Versions can be specific to the current shell only (`jenv shell`) or for a specific directory (`jenv local`). 

Given macOS already has a shim (based on `JAVA_HOME`), automatically switching based on the current directory is probably the only real advantage of jenv. Or if you need a consistent ways across Linux & macOS to switch java versions.

## sdkman

[sdkman](https://github.com/sdkman/sdkman-cli) will install versions of java (and gradle and spark) as well as let you switch between them. However, installations are independent from brew.
