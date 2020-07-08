

# Docker!
## What is it? 
![Screwdriver](https://media.qcsupply.com/media/catalog/product/cache/122b61bfb663175d7f1bbb5dbb7f535b/3/5/350679-3_2.jpg)

## What you can do with it?

# Preamble
- Ask lots of questions
- Don't believe everything I say
	1. Docker is a fast moving target.  What is true now will likely change
	2. I misspeak. I confuse left with right, right with left, etc. 
	3. My environment is likely different than yours.  Versions, OS, systems all matter.
- Call me on it when something doesn't sound right.

# What can you do with Docker?
Top three uses for Docker containers
- Create a learning, development, troubleshooting virtual machine-like environment
- Run services, e.g. a web server
- Run individual commands

# VM-like environment
```bash
docker run --rm -i -t ubuntu
# you get a shell, in this case /bin/bash
ls -la /home                         # filesystem
df -hTPl                             # filesystem
ps faux                              # process table
grep proc /proc/cpuinfo | tail -1    # CPUs
free -tm                             # RAM
```

# Service
For example, a web server
```bash
docker run --name nginx -p 80:80 -d nginx

elinks http://127.0.0.1/
```


# Single command
```bash
docker run hello-world
```
```bash
docker run --rm ubuntu date
```

# Docker environment
Run these on the host that is running the Docker service
```bash
docker container list     # list running containers
docker container list -a  # list all containers
docker image list         # list images
docker image list -a      # list all images
```

# A bit more on interactive environment
```bash
docker run --rm -i -t --name demo ubuntu
^p^q                             # detaches from container instance
docker container list            # list running containers
```

- CONTAINER ID
- NAMES

```bash
docker container attach demo     # reattach to container
ps faux
exit
docker container list            # list running containers
```

# Docker run options

```bash
docker run --rm -i -t --name demo ubuntu
```

```
--rm          # remove the container instance on exit
-i            # make interactive
-t            # Allocate a pseudo-TTY
--name        # assign a name to the container instance
```

# More Docker options

```bash
docker --help
docker run --help
```

```
--help        # get help on a command
```

# Management commands
"New" way of working with docker.
Format is **docker {object} {command} {options} {arguments}**

```bash
docker ps -a                   # old way
docker container list -a       # new way
```

# A bit more on interactive containers
Create a network toolbox

```bash
docker run --rm -i -t --name my-nettools ubuntu
# doesn't work
ping -c 1 google.com
curl -s 'https://api.ipify.org?format=json' ; echo
# install software
apt-get update
apt-get install -y man-db vim tree less net-tools elinks tidy procps \
   nmap curl telnet iputils-ping dnsutils iproute2 traceroute jq git rsync
# try again
ping -c 1 google.com
curl -v -s 'https://api.ipify.org?format=json' ; echo
curl -s 'https://api.ipify.org?format=json' | jq -r .ip
``` 

Saving your work

```bash
^p^q     # detach
docker image list                        # list images
docker commit my-nettools my-net-ubuntu  # save the my-nettools container as an image called my-net-ubuntu
docker image list                        # list images
docker container list                    # list running containers
docker attach my-nettools                # reattach
exit
docker container list                    # list running containers
docker run --rm -it my-net-ubuntu        # create new container instance containing network tools
curl -s 'https://api.ipify.org?format=json' | jq -r .ip
exit
```

Wash, rinse, repeat.  You now have a way to try things out within a container and take a point-in-time snapshot.


# A bit more on single commands

```bash
docker run --rm my-net-ubuntu curl -s 'https://api.ipify.org?format=json'
alias my.curl='docker run --rm my-net-ubuntu curl -s'
my.curl 'https://api.ipify.org?format=json'
```

Piping standard input into a Docker container: use the `-i` option.

```bash
alias my.jq='docker run --rm -i my-net-ubuntu jq '
my.curl 'https://api.ipify.org?format=json' | my.jq .
```

# Alternative to attach/detach

```bash
docker create -it --name demo-exec my-net-ubuntu       # create a container instance
docker start demo-exec                                 # start the container
docker exec demo-exec date                             # run a command within the running container
docker exec -it demo-exec /bin/bash                    # exec into the container
ps faux
exit
docker container list                                  # list running containers
docker stop  demo-exec                                 # stop the container
docker rm  demo-exec                                   # delete the container
```

Here we have a running container that we can exec into to run commands, even interactive commands.  That is useful for debugging running containers.


# A bit more on services

```bash
docker container list                                  # list running containers
docker exec -it mynginx1 /bin/bash
ps faux                                                # doesn't work
apt-get update                                         # install our favorite software
apt-get install -y man-db vim tree less net-tools elinks tidy procps \
   nmap curl telnet iputils-ping dnsutils iproute2 traceroute jq
ps faux                                                # now it works
curl -s localhost | elinks --dump
vi /usr/share/nginx/html/index.html
kill -1 1
ps faux
curl -s localhost | elinks --dump
exit
```

### Why does this not work?

```bash
curl -s http://10.246.141.151 | elinks --dump          # works fine
my.curl -s http://10.246.141.151 | elinks --dump       # works fine
curl -s localhost | elinks --dump                      # works fine

my.curl -s localhost | elinks --dump                   # doesn't work
```


# Stepping back: Docker objects
  - Container Instances
  - Layers
  - Registry
  - Repository
  - Images
  - Tags
  - Volumes
  - Networks
  - Swarms
  - Pods

# Docker objects and commands
[[https://github.com/rwcitek/docker/blob/master/draw.io/Docker.flow.png]]

# What actions can be performed on a container instance?
- CRUD database like operations
  - **C**reating - run, create - id/sha, name
  - **R**ead/query - inspect
  - **U**pdate - state (pause, stop, start, kill), other properties
  - **D**elete - rm
  - commit, save, list, inspect
- States
  - stopped
  - paused
  - running
- Cannot do
  - create container from a container; create image and then create container
  - modify CPU, RAM; launch new container with options on RAM, CPU
 

# How to get an image: Registry, Repository, local cache
### Registry, Repository, Tag, Image
* A Registry is a host that contains a collection of Repositories.
	* If a Registry is not specified, dockerhub.com is the default
* A Repository contains a collection of tagged images.
* A Tag is an identifier for an Image.  An Image can have multiple tags. 
* An Image is specified by the unique combination of a Repository and Tag and is identified by its Image ID.
  * If a Tag is not specified in a pull request, "latest" is the default

Examples:
- Default: dockerhub

```
docker pull ubuntu
```

```
  registry = dockerhub.om
repository = ubuntu
       tag = latest
     image = ubuntu:latest
```

- Amazon ECR

```
docker pull 313257557546.dkr.ecr.us-east-1.amazonaws.com/pdxmolab/pdx_ppmp/tools:ppmp-fastqc-0.11.5-1
```

```
  registry = 313257557546.dkr.ecr.us-east-1.amazonaws.com
repository = pdxmolab/pdx_ppmp/tools
       tag = ppmp-fastqc-0.11.5-1
     image = pdxmolab/pdx_ppmp/tools:ppmp-fastqc-0.11.5-1
```

Note that slashes '/' in a repository's name have no semantic meaning.

### Confusing

```
$ docker container list
CONTAINER ID  IMAGE         COMMAND      CREATED         STATUS        PORTS  NAMES
c462d4048fc5  my-net-ubuntu "/bin/bash"  45 minutes ago  Up 44 minutes        demo-exec
```

```
$ docker image list
REPOSITORY    TAG     IMAGE ID      CREATED           SIZE
my-net-ubuntu latest  1ce74ad4077a  About an hour ago 240MB
```

```
$ docker pull --help
Usage:  docker pull [OPTIONS] NAME[:TAG|@DIGEST]
Pull an image or a repository from a registry

Options:
-a, --all-tags  Download all tagged images in the repository
```


# Building an image with a Dockerfile
A Dockerfile is a collection of commands used to build an image




# Best Practices
DO:
- create snapshots (commit) often while working in an interactive container
- turn your history from the interactive container into a Dockerfile
- pass passwords into containers via run-time options or a mounted volumes

DO NOT:
- use snapshot images for creating containers that are not for development
- use DockerHub within the PSJH environment
- put passwords into your Dockerfile
- use an ENV file with docker-compose: good idea, poorly implemented

# References
- https://docs.docker.com/get-started/


# Future topics

- [Containers vs Virtual machines](https://docs.docker.com/get-started#containers-and-virtual-machines)

- [Networks](https://success.docker.com/article/networking#userdefinedbridgenetworks)

- Philosophy
  - [Cattle vs pets](http://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/#understanding-pets-and-cattle)



<hr />

- Markdown written with [StackEdit](https://stackedit.io/).
- Diagrams with [DrawIO](https://www.draw.io/).
