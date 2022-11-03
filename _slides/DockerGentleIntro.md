---
title: Gentle Intro to Docker
description: Introducing Docker
theme: black
---

# Docker!

This presentation will show you examples of what it can do.

----

## What is it? 
![Red Paperclip](https://upload.wikimedia.org/wikipedia/commons/1/1c/One_red_paperclip.jpg)

----

## What you can do with it?
![Red Paperclip](https://upload.wikimedia.org/wikipedia/commons/1/1c/One_red_paperclip.jpg)


[Trade for a house?](https://en.wikipedia.org/wiki/One_red_paperclip)

----

## Preamble
- Ask lots of questions
- Don't believe everything I say
	1. Docker is a fast moving target.  What is true now will likely change ... soon.
	2. I misspeak. Left instead of right, up instead of down, etc.
	3. My environment is likely different than yours.  Versions, OS, platforms all matter.
- Call me on it when something doesn't sound right.

---

## What is Docker?

![Docker](https://avatars.githubusercontent.com/u/5429470?s=200&v=4)


---

## What is Docker?

- Light-weight virtual machine
- A container system

---
## Use cases

- "Appliance" that generates QR codes
- Genomics pipeline
- Conver 10,000 images to TIFF w/metadata

---

## What can you do with Docker?

Top three "modes" for Docker containers
1. Run individual commands
1. Create a learning, development, troubleshooting virtual machine-like environment
1. Run services, e.g. a web server

---

## Single command
```bash
$ docker run --rm hello-world
```
```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
...
```
---

## Single command

```bash
$ echo 'Hello, world!' |
  docker run --rm -i rwcitek/barcode-gen \
  qrencode --type=PNG --level=H -o - > hello-world.qrcode.png
```

<img src="../../public/hello-world.qrcode.png" alt="slide" width="400"/>

---

## Single command

```bash
$ cat hello-world.qrcode.png |
  docker run --rm -i rwcitek/barcode-gen \
  zbarimg -q --nodbus --raw -
```
```
Hello, world!

```

---

## VM-like environment
```bash
$ docker run --rm -i -t ubuntu
```
```
root@4942f12c4b8d:/# ps faux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  1.1  0.1   4624  3708 pts/0    Ss   19:04   0:00 bash
root        10  0.0  0.0   7060  1640 pts/0    R+   19:04   0:00 ps faux
```

---

## Service
For example, a web server
```bash
$ docker run --name nginx -p 8080:80 -d nginx
$ elinks --dump http://127.0.0.1:8080 | head -3
```
```
                               Welcome to nginx!

   If you see this page, the nginx web server is successfully installed and
...
```

---

## Service
nginx

http://penguin.linux.test:8080/

---

## Docker environment
Run these on the host that is running the Docker service
```bash
docker container list     # list running containers
docker container list -a  # list all containers
docker image list         # list images
docker image list -a      # list all images
```

---

## Docker run options

```bash
docker run --rm -i -t --name demo ubuntu
```

```
--rm          # remove the container instance on exit
-i            # make interactive
-t            # allocate a pseudo-TTY
--name        # assign a name to the container instance
```


---

## More Docker options

```bash
docker --help
docker run --help
```

---

## Management commands
Syntax is **docker {object} {command} {options} {arguments}**

```bash
docker container exec -it demo date
docker image list -a
```


---

## A bit more on interactive containers
Create a network toolbox - pt1

```bash
docker run -i -t --name my-nettools ubuntu /bin/bash
# doesn't work
ping -c 1 google.com
curl -s 'https://api.ipify.org?format=json' ; echo
```

---

## A bit more on interactive containers
Create a network toolbox - pt2

```
# install software
apt-get update
apt-get install -y man-db vim tree less net-tools elinks tidy procps \
   nmap curl telnet iputils-ping dnsutils iproute2 traceroute jq git rsync
```

---

## A bit more on interactive containers
Create a network toolbox - pt3

```
# try again
ping -c 1 google.com
curl -v -s 'https://api.ipify.org?format=json' ; echo
curl -s 'https://api.ipify.org?format=json' | jq -r .ip
``` 

---

## Saving your work

```bash
docker container list -a                 # list instances
docker image list -a                     # list images
docker commit my-nettools my-net-ubuntu  # save instance as image
docker image list -a                     # list images
docker container list -a                 # list instances
docker container exec -it my-nettools /bin/bash   # connect
exit
docker container list                    # list running containers
docker run --rm -it my-net-ubuntu        # create new container instance containing network tools
curl -s 'https://api.ipify.org?format=json' | jq -r .ip
exit
```

Wash, rinse, repeat.  You now have a way to try things out within a container and take a point-in-time snapshot.



---

## A bit more on single commands

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

---

## A bit more on services

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


---

## Why does this not work?

```bash
curl -s http://10.246.141.151 | elinks --dump          # works fine
my.curl -s http://10.246.141.151 | elinks --dump       # works fine
curl -s localhost | elinks --dump                      # works fine

my.curl -s localhost | elinks --dump                   # doesn't work
```



---

## Stepping back: Docker objects
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


---

## Docker objects and commands
![docker flow](https://github.com/rwcitek/docker/blob/master/draw.io/Docker.flow.png?raw=true)


---

## What actions can be performed on a container instance?
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
 


---

## How to get an image: Registry, Repository, local cache
### Registry, Repository, Tag, Image
* A Registry is a host that contains a collection of Repositories.
	* If a Registry is not specified, dockerhub.com is the default
* A Repository contains a collection of tagged images.
* A Tag is an identifier for an Image.  An Image can have multiple tags. 
* An Image is specified by the unique combination of a Repository and Tag and is identified by its Image ID.
  * If a Tag is not specified in a pull request, "latest" is the default


---

## Examples: dockerhub (default)
```
docker pull ubuntu

docker pull dockerhub.com/ubuntu:latest
```

```
  registry = dockerhub.com
repository = ubuntu
       tag = latest
     image = ubuntu:latest
```


---

## Examples: Amazon ECR

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


---

## Confusing

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



---

## Building an image with a Dockerfile
A Dockerfile is a collection of commands used to build an image
```
# this doesn't work
docker run --rm -it ubuntu curl -L -s -I google.com
``
``
cat <<'eof' > Dockerfile
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y man-db vim tree less net-tools elinks tidy procps \
            nmap curl telnet iputils-ping dnsutils iproute2 traceroute jq git rsync
eof

docker build --tag nettools .

docker run --rm -it nettools curl -L -s -I google.com
```



---

## Best Practices
DO:
- create snapshots (commit) often while working in an interactive container
- turn your history from the interactive container into a Dockerfile
- pass passwords into containers via run-time options or a mounted volumes

DO NOT:
- use snapshot images for creating containers that are not for development
- put passwords into your Dockerfile
- use an ENV file with docker-compose: good idea, poorly implemented


---

## References
- https://docs.docker.com/get-started/



---

## Future topics

- [Containers vs Virtual machines](https://docs.docker.com/get-started#containers-and-virtual-machines)

- [Networks](https://success.docker.com/article/networking#userdefinedbridgenetworks)

- Philosophy
  - [Cattle vs pets](http://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/#understanding-pets-and-cattle)

<hr />

- Markdown written with [StackEdit](https://stackedit.io/).
- Diagrams with [DrawIO](https://www.draw.io/).
