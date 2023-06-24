# Docker Desktop for Mac

## Install

Install Docker Desktop, which uses its own hypervisor ([HyperKit](https://github.com/moby/hyperkit) based on xhyve):

```
brew cask install docker
```

Start docker from spotlight search - command+space - docker.
This starts docker and creates a symlink to the `docker` & `docker-compose` cli tools in `/usr/local/bin/docker`

Docker Desktop (aka docker-for-mac) is more integrated and recommended than the older docker-machine (the new boot2docker) which is part of the Docker Toolbox and uses a Virtualbox VM running Linux. The Virtualbox VM has a separate IP address so you have to tell the Docker command line tools to talk to the VM using the docker-machine cli. It is installed via `brew install docker docker-compose`. See [Docker Desktop on Mac vs. Docker Toolbox](https://docs.docker.com/docker-for-mac/docker-toolbox/)

## Installing the man pages

Desktop Desktop for mac doesn't install any manpages.

See [cmosetick/docker-manpages-osx](https://github.com/cmosetick/docker-manpages-osx) or

```
git clone https://github.com/docker/docker-ce.git
cd docker-ce
# checkout relevant version
git checkout 18.06
cd components/cli
make -f docker.Makefile manpages
echo "MANPATH $PWD/man" | sudo tee -a /private/etc/man.conf
```

## LinuxKit

Docker Desktop runs as a [LinuxKit](https://github.com/linuxkit/linuxkit) [HyperKit](https://github.com/moby/hyperkit) process. Because of this you won't see docker container processes in `ps`. To connect to the LinuxKit host, either

- the nsenter1 image (recommended): `docker run -it --rm --privileged --pid=host justincormack/nsenter1`
- screen:

  ```
  screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty
  ```

  NB:

  - to exit, kill the screen (Ctrl-a k). If you detach (Ctrl-a d), make sure your reattach to the same screen. If you attach a second screen you'll get garbled text. Killing all sessions will resolve the issue, see [[Screen]]
  - screen contains extra debug output that you probably don't need, scrollback doesn't work by default, and `less` doesn't use the whole screen.

More info on both options [here](https://gist.github.com/BretFisher/5e1a0c7bcca4c735e716abf62afad389)

The Docker Desktop LinuxKit kernel is something like `4.9.93-linuxkit-aufs`. It is a custom built downstream from LinuxKit itself ([ref](https://github.com/docker/for-mac/issues/3050#issuecomment-402504883))

## Troubleshooting

High CPU - [#1759](https://github.com/docker/for-mac/issues/1759#issuecomment-583706239), [#4362](https://github.com/docker/for-mac/issues/4362#issuecomment-647101073)

Preferences window stuck loading - [#4374](https://github.com/docker/for-mac/issues/4374#issuecomment-647075555)

Kubernetes stuck starting - [#4624](https://github.com/docker/for-mac/issues/4624#issuecomment-647103959). Docker - Troubleshoot - Reset to factory defaults (nb: this will remove all images and containers)

## Logs

[Tailing the logs](https://docs.docker.com/docker-for-mac/troubleshoot/#check-the-logs)

Logs: `~/Library/Containers/com.docker.docker/Data/log/vm/`

`docker events` will tail docker events

## SSH Agent

See [SSH agent forwarding](https://docs.docker.com/desktop/networking/#ssh-agent-forwarding) on how to expose the ssh agent to the container using the magic mount point _/run/host-services/ssh-auth.sock_.

By default _/run/host-services/ssh-auth.sock_ only allows write access to root, eg:

```
srwxr-xr-x 1 root root 0 May 30 03:16 /run/host-services/ssh-auth.sock
```

If running in the container as non-root, you'll need to give them write on the socket, eg:

```
sudo chmod a+w /run/host-services/ssh-auth.sock
```

> Error connecting to agent: Permission denied

You don't have write access to the socket.

> Could not open a connection to your authentication agent.

You don't have the SSH_AUTH_SOCK env var set.
