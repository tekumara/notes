# yum

`rpm -qf /usr/sbin/adduser` to show the package that owns/installed myfile  
`repoquery -l java-1.8.0-openjdk` list files installed for the package `java-1.8.0-openjdk`  
`yum info glibc` show installed and available package versions and info  
`yum list java*` list installed and available packages beginning with `java`  
`yum list installed java*` list installed packages only beginning with `java`  
`yum search omp` search available packages for `omp`  

```
yum install -y epel-release
yum-config-manager --enable epel
yum repolist
```
