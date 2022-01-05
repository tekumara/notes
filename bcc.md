# Build for debian:stretch

Build .deb files 
```
DEBIAN_RELEASE=stretch &&     echo "deb http://deb.debian.org/debian ${DEBIAN_RELEASE} non-free" >         /etc/apt/sources.list.d/debian-non-free.list &&     apt-get -qq update &&     apt-get -y install pbuilder aptitude
git clone https://github.com/iovisor/bcc.git
(cd bcc && /usr/lib/pbuilder/pbuilder-satisfydepends &&     ./scripts/build-deb.sh)
dpkg -i bcc/*bcc*.deb
```

Install pre-built .deb files
```
apt-get install -y binutils python3
dpkg -i *bcc*.deb
```

# Build from source for ubuntu bionic

```
sudo apt-get -y install bison build-essential cmake flex git libedit-dev \
  libllvm6.0 llvm-6.0-dev libclang-6.0-dev python zlib1g-dev libelf-dev
```

# Run docker container

Uses kernel headers from the host, runs privileged, and has access to the host's PID namespace (`--pid=host`):
```
docker run -it --rm \
  --privileged \
  -v /lib/modules:/lib/modules:ro \
  -v /usr/src:/usr/src:ro \
  -v /etc/localtime:/etc/localtime:ro \
  --workdir /usr/share/bcc/tools \
  --pid=host \
  zlim/bcc
```


# Install bcc inside a container

```
# copy the deb files into a debian container
docker cp bcc 51c8fea19348:/
# enter container
docker exec -it --user root 51c8fea19348 bash
# install
apt-get install -y binutils python3
dpkg -i /bcc/*.deb
exit
```

bcc needs to run in privileged mode. If you container is already started on the host, you can run it from the host by entering the container's namespace, which now contains bcc, along with the application libraries:

DOES THIS GIVE THE NAMESPACE PRIVILEDGED MODE???
```
sudo nsenter -t `pidof java` -m /usr/share/bcc/tools/trace 'SyS_write (arg1==1) "%s", arg2' -U -p `pidof java`
```

# Build custom version of the zlim/bcc ubuntu bionic docker container

```
# build .deb packages
sudo yum install -y 
git clone https://github.com/iovisor/bcc.git
cd bcc
git fetch origin pull/2030/head:pr2030
git checkout pr2030
sudo docker build -t bcc:pr2030 -f Dockerfile.ubuntu .

# install built .deb packages
sudo docker run -it bcc/bionic:pr2030 sh -c 'dpkg -i *bcc*.deb'

# commit changes to image bcc (overwrite the previous dpkg command)
sudo docker commit --change='CMD ["/bin/bash"]' $(sudo docker ps -lq) bcc

# run
sudo yum -y install kernel-devel-$(uname -r)
sudo mount -t debugfs debugfs /sys/kernel/debug
sudo docker run -it --privileged   -v /sys/kernel/debug:/sys/kernel/debug:rw -v /lib/modules:/lib/modules:ro   -v /usr/src:/usr/src:ro   -v /etc/localtime:/etc/localtime:ro   --workdir /usr/share/bcc/tools   --pid=host   bcc
/usr/share/bcc/tools/execsnoop
exit

# re-enter container
sudo docker ps -lq # to get container id
sudo docker start -i 22de24248ccc
```

# Run container with access to headers and bcc

```
docker run -it \
  -v /lib/modules:/lib/modules:ro \
  -v /usr/src:/usr/src:ro \
  -v /usr/share/bcc:/usr/share/bcc:ro
```

To specify the equivalent bind mounts for EB/ECS:

```
            "mountPoints": [
                {
                    "readOnly": true,
                    "containerPath": "/lib/modules",
                    "sourceVolume": "lib-modules"
                },
                {
                    "readOnly": true,
                    "containerPath": "/usr/src",
                    "sourceVolume": "usr-src"
                },
                {
                    "readOnly": true,
                    "containerPath": "/sys/kernel/debug",
                    "sourceVolume": "sys-kernel-debug"
                }
            ],
...
             "volumes": [
                    {
                        "name": "lib-modules",
                        "host": {
                            "sourcePath": "/lib/modules"
                        }
                    },  
                    {
                        "name": "usr-src",
                        "host": {
                            "sourcePath": "/usr/src"
                        }
                    }, 
                    {
                        "name": "sys-kernel-debug",
                        "host": {
                            "sourcePath": "/sys/kernel/debug"
                        }
                    }
             ]       

```

# Vs perf

perf can capture the stack trace at the point of being switched out.  I was looking at the off-cpu tool from bcc, but then discovered that it was much easier in perf.

# Errors

```
/virtual/main.c:20:1: error: could not open bpf map: Operation not permitted is maps/stacktrace map type enabled in your kernel?
```

run with sudo, or if in a docker container make sure it is running in privileged mode


# Test

```
/usr/share/bcc/tools/execsnoop
/usr/share/bcc/tools/trace 'SyS_write (arg1==1) "%s", arg2' -U -p `pidof java`
```

# Diag

cat /boot/config-* | grep BPF
CONFIG_CGROUP_BPF=y
CONFIG_BPF=y
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NET_CLS_BPF=m
CONFIG_NET_ACT_BPF=m
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_BPF_EVENTS=y
# CONFIG_TEST_BPF is not set
CONFIG_CGROUP_BPF=y
CONFIG_BPF=y
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NET_CLS_BPF=m
CONFIG_NET_ACT_BPF=m
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_BPF_EVENTS=y
# CONFIG_TEST_BPF is not set

cat /boot/config-`uname -r`|grep KPROBE
CONFIG_KPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBES_SANITY_TEST is not set
