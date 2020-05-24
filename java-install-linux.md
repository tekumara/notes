# Java linux install

## Install open jdk8 on Amazon linux

```
sudo yum install java-1.8.0-openjdk-devel.x86_64
```

To make 1.8 the default:
```
sudo /usr/sbin/alternatives --config java
sudo /usr/sbin/alternatives --config javac
```
or altenatively remove 1.7:
```
sudo yum remove java-1.7.0-openjdk
```

[ref](https://serverfault.com/questions/664643/how-can-i-upgrade-to-java-1-8-on-an-amazon-linux-server)

## Install jdk8 on Ubuntu

OpenJDK

`sudo apt-get install openjdk-8-jdk`

OracleJDK

```
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install oracle-java9-installer
```

## Choosing the default Java to use

This will display all java versions, indicate the current one, and switch the `/usr/bin/java` symlink to another version.

`sudo update-alternatives --config java`

Auto mode - the alternatives system will automatically decide, as packages are installed and removed, whether and how to update the links. 

Manual mode, the alternatives system will not change the links; it will leave all the decisions to the system administrator. 

[man update-alternatives](http://linux.die.net/man/8/update-alternatives)

## The type JComboBox is not generic; it cannot be parameterized with arguments \<Object\>

/usr/lib/jvm/java-6-openjdk-amd64/jre/lib/rt.jar contains:

JComboBox.java (version 1.5: 49.0, super bit) without generics.

==> Switch to java-7-openjdk-amd64


