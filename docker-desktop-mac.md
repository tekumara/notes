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

See [SSH agent forwarding](https://docs.docker.com/desktop/networking/#ssh-agent-forwarding).

If you get `Could not open a connection to your authentication agent.` then make sure non-root can write to the socket, eg:

```
sudo chmod o+w /run/host-services/ssh-auth.sock
```

## Disk usage

`docker system df` will show docker disk utilization summary - images, containers, volumes  
`docker system df -v` a break-down at the individual image/container/volume level including shared size (ie: shared layers), unique size (ie: unique layers).

`docker system df -v | grep $volume` to show size of specific volume or alternatively: `docker run --rm -it -v /:/vm-root alpine du -sHh /vm-root$(docker volume inspect --format '{{ .Mountpoint }}' $volume)`

Docker Desktop stores Linux containers and images in a single, large “disk image” file, located at `~/Library/Containers/com.docker.docker/Data/vms/0/data`

`ls -klsh ~/Library/Containers/com.docker.docker/Data/vms/0/data` will show the actual disk usage vs maximum:

```
total 68167208
 68167208 -rw-r--r--  1 tekumara  staff   104G 21 Jun 17:23 Docker.raw
```

Actual usage is 68MB, max is 104G. To increase the max: _Docker - Preferences - Resources - Disk image size_

`docker images --format "{{.ID}}\t{{.Size}}\t{{.Repository}}:{{.Tag}}" | sort -k 2 -h` images sorted by size

[Dangling images](https://docs.docker.com/engine/reference/commandline/images/#show-untagged-images-dangling) are untagged leaf images (ie: not intermediate layers).

`docker images -f dangling=true` list dangling images and their size

Unused images are images that aren't associated with a container (includes all dangling images)

`grep -xvf <(docker ps -a --format '{{.Image}}') <(docker images | tail -n +2 | awk '{ print $1":"$2 }')` unused images

## Pruning

`docker image prune` remove dangling images
`docker image prune -a --filter 'until=1440h'` remove unused images (dangling or otherwise) created earlier than 60 days ago
`docker image rm $repo:$tag` remove specific image

Pruning images does not automatically remove them from the build cache. It just removes the tag. So the total reclaimed space can be 0.

`docker volume prune` remove all unused local volumes

`docker container prune` remove all stopped containers
`docker container prune --filter 'until=1440h'` remove all containers created earlier than 60 days ago

After removing containers you can remove their image.

To prune everything:

`docker system prune` remove all stopped containers (will delete k3d clusters not running!), unused networks, dangling images, dangling build cache objects
`docker system prune --volumes` remove above + volumes associated with the stopped containers
`docker system prune -a` remove all stopped containers + all images + networks associated with those containers (ie: unused images), and the whole build cache  
`docker system prune -a --volumes` above + volumes too

See also: [Disk utilization in Docker for Mac](https://docs.docker.com/docker-for-mac/space/)
