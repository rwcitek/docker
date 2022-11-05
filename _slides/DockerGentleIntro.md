---
title: Gentle Intro to Docker
description: Introducing Docker
theme: black
---

# Docker!

This presentation will show you examples of what it can do.

![Docker](https://avatars.githubusercontent.com/u/5429470?s=600&v=4)

{[Slides here](https://rwcitek.github.io/docker/slides/DockerGentleIntro/#/)}

---

## Preamble
- Ask lots of questions
- Don't believe everything I say
	1. Docker is a fast moving target.  What is true now will likely change ... soon.
	2. I misspeak. Left instead of right, up instead of down, etc.
	3. My environment is likely different than yours.  Versions, OS, platforms all matter.
- Call me on it when something doesn't sound right.

----

## Roadmap
- Use cases
- Common "modes"
- Why?
- Docker objects and commands
- Registry
- Workflow
- Best Practices
- Who uses Docker


----

## What is it? 
![Red Paperclip](https://upload.wikimedia.org/wikipedia/commons/1/1c/One_red_paperclip.jpg)

----

## What you can do with it?
![Red Paperclip](https://upload.wikimedia.org/wikipedia/commons/1/1c/One_red_paperclip.jpg)


[Trade for a house?](https://en.wikipedia.org/wiki/One_red_paperclip)

---

## What is Docker?

![Docker](https://avatars.githubusercontent.com/u/5429470?s=600&v=4)

---

## What is Docker?

- Light-weight virtual machine
- A container system

---
## Use cases

- "Appliance" that generates QR codes
- Genomics pipeline
- Convert 10,000 images to TIFF w/metadata

---

## How can you use Docker?

Top three "modes" for Docker containers
1. Run individual commands
1. Create a learning, development, troubleshooting virtual machine-like environment
1. Run services, e.g. a web server

---

## Single command
Say Hello

```
$ docker run --rm hello-world
```
```
Hello from Docker!
This message shows that your installation appears
to be working correctly.

To generate this message, Docker took the
following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world"
    image from the Docker Hub.
...
```
---

## Single command

Say hello in a QR code

```
$ echo 'Hello, world!' |
  docker run --rm -i rwcitek/barcode-gen \
    qrencode --type=PNG --level=H -o - \
  > hello-world.qrcode.png

```

<img src="../../public/hello-world.qrcode.png" alt="slide" width="300"/>

---

## Single command

Decode the QR code

```
$ cat hello-world.qrcode.png |
  docker run --rm -i rwcitek/barcode-gen \
    zbarimg -q --nodbus --raw -

```
```
Hello, world!

```

---

## Single command

QR code for this slide deck

```
$ echo 'https://rwcitek.github.io/docker/slides/DockerGentleIntro/' |
  docker run --rm -i rwcitek/barcode-gen \
    qrencode --type=PNG --level=H -o - \
  > docker.qrcode.png

```

<img src="../../public/docker.qrcode.png" alt="slide" width="300"/>

---

## VM-like environment

Run Ubuntu ...

```
$ docker run --rm -i -t ubuntu

```
```
root@85f5a93206e9:/# head -5 /etc/os-release 
PRETTY_NAME="Ubuntu 22.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.1 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy

root@85f5a93206e9:/# 

```

---

## VM-like environment

... or Fedora, Slackware, etc.

```
$ docker run --rm -i -t fedora

```
```
[root@7652568cd347 /]# head -5 /etc/os-release 
NAME="Fedora Linux"
VERSION="36 (Container Image)"
ID=fedora
VERSION_ID=36
VERSION_CODENAME=""

[root@7652568cd347 /]# 
```

---

## Service

For example, the nginx web server

```
$ docker run -d --name nginx -p 8080:80 nginx

$ elinks --dump http://127.0.0.1:8080

```
```
		       Welcome to nginx!

   If you see this page, the nginx web server is successfully
   installed and working. Further configuration is required.

```

---

## Service
[http://localhost:8080/](http://penguin.linux.test:8080/)

<img src="../../public/nginx.png" alt="slide" width="800"/>


---

## Service
[http://localhost:8080/](http://penguin.linux.test:8080/)

<img src="../../public/nginx.png" alt="slide" width="500"/>
<img src="../../public/nginx.png" alt="slide" width="500"/>

---

## Why use Docker?

<span class="fragment">Resource Isolation</span>

<span class="fragment">
  <img src="https://sd.keepcalms.com/i/keep-calm-what-happens-in-vegas-stays-in-vegas-18.png" alt="vegas" width="400"/>
</span>

---

## Why use Docker?
What happens in Docker ...

<span class="fragment">... stays in Docker</span>

---

## Resource Isolation
- Process
- Memory
- File system
- Networking
- Other hardware

---

## Implications
- more than one environment
- throw-away environments
- testing environments; mistakes
- consistent environments
- portable
- ... many others

---

## Objects in a Docker Environment

  - **Container Instances**
  - **Container Images**
  - Registry
  - Repository
  - Tags
  - Volumes
  - Layers
  - Networks
  - Swarms
  - Pods

---

## Docker objects and commands

<img src="https://github.com/rwcitek/docker/blob/master/draw.io/Docker.flow.png?raw=true" alt="Docker objects" width="800"/>

---

## What actions can be performed on a container instance?

- CRUD database like operations
  - **C**<span class="fragment">reating - run, create - id/sha, name</span>
  - **R**<span class="fragment">ead/query - inspect</span>
  - **U**<span class="fragment">pdate - change state (pause, stop, start, kill)</span>
  - **D**<span class="fragment">elete - rm</span>
 
---

## What actions CANNOT be performed on a container instance?

- create container from a container
  - instead: create image and then create container
- modify CPU, RAM, Volumes, Network
  - instead: launch new container with new options

---

## Building an image with a Dockerfile
A Dockerfile is a collection of commands used to build an image

```
cat <<'eof' > Dockerfile
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y man-db vim tree less net-tools \
      elinks tidy procps nmap curl telnet iputils-ping \
      dnsutils iproute2 traceroute jq git rsync
CMD ["/bin/bash"]
COPY Dockerfile /
eof

docker build --tag nettools .

docker run --rm nettools \
  curl -L -s -I google.com

```

---

## Building an image with an Here-Doc Dockerfile
```
<<'eof' docker build --tag nettools:here-doc -
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y man-db vim tree less net-tools \
      elinks tidy procps nmap curl telnet iputils-ping \
      dnsutils iproute2 traceroute jq git rsync
COPY Dockerfile /
eof

docker run --rm nettools:here-doc \
  curl -L -s -I google.com

```

---

## Configuration Workflow

1. Run an instance as a service ( -d )
1. Exec into the instance
1. Modify the instance
1. Exit the instance
1. Commit the instance to an image
1. Repeat from step 2
1. Convert command history into a Dockerfile
1. Test the Dockerfile
1. Push to registry
1. Clean up

----

## Configuration Workflow

{ Demo }

~~

## Workflow - Instance as a service

```
$ docker container run -d --name net-tools \
    ubuntu:22.04 sleep inf

```

~~

## Workflow - Exec

```
$ docker container exec -it net-tools /bin/bash

```

~~

## Workflow - Modify

```
# export DEBIAN_FRONTEND=noninteractive
# apt-get update
# apt-get install -y iputils-ping

```

~~

## Workflow - Exit

```
# exit

```

~~

## Workflow - Commit

```
$ docker container commit net-tools net-tools:1

```

~~

## Workflow - Repeat
  1. Exec into the instance
  1. Modify the instance
  1. Exit the instance
  1. Commit the instance to an image

~~

## Workflow - History to Dockerfile

```
$ cat Dockerfile
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y iputils-ping
CMD ["/bin/bash"]
COPY Dockerfile /

$ docker build --tag net-tools .

```

~~

## Workflow - Test

```
$ docker container run --rm net-tools \
    ping -c 1 www.google.com

```
```
PING www.google.com (142.250.69.228) 56(84) bytes of data.
64 bytes from den08s05-in-f4.1e100.net (142.250.69.228): icmp_seq=1 ttl=114 time=36.8 ms

--- www.google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 36.781/36.781/36.781/0.000 ms

```

~~

## Workflow - Push

```
$ docker tag net-tools rwcitek/net-tools:example
$ docker login
$ docker image push rwcitek/net-tools:example

```
~~

## Workflow - Clean up

```
$ docker container stop net-tools 
$ docker container rm net-tools 
$ docker image list -a |
  awk '$2 ~ /net-tools:[0-9]/ {print $1} |
  xargs docker image rm

```

---

## How to get an image
* A Registry is a host that contains a collection of Repositories.
  * If a Registry is not specified, `dockerhub.com` is the default
* A Repository contains a collection of tagged images.
* A Tag is an identifier for an Image.  An Image can have multiple tags. 
* An Image: Repository + Tag. Given a unique Image ID.
  * If a Tag is not specified, `:latest` is the default

---
## Example: local cache

```
$ docker image list -a

```
```
REPOSITORY            TAG          IMAGE ID       CREATED         SIZE
rwcitek/dsub          1667492740   3e5f71ce3e49   38 hours ago    1.93GB
rwcitek/dsub          latest       3e5f71ce3e49   38 hours ago    1.93GB
net-tools             latest       1677586800bd   2 days ago      945MB

```
```
$ docker image inspect net-tools | jq -r .[0].Id

```
```
sha256:1677586800bd6fd737c73d470b3dbeb8473d9683dbeeea3cfb7b8b7ed50faa5d

```
---

## Example: dockerhub
DockerHub is the default

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

## Example: Amazon ECR

```
docker pull \
  313257557546.dkr.ecr.us-east-1.amazonaws.com/pdxmolab/pdx_ppmp/tools:ppmp-fastqc-0.11.5-1
```
```
  registry = 313257557546.dkr.ecr.us-east-1.amazonaws.com
repository = pdxmolab/pdx_ppmp/tools
       tag = ppmp-fastqc-0.11.5-1
     image = pdxmolab/pdx_ppmp/tools:ppmp-fastqc-0.11.5-1
```

Note that slashes '/' in a repository's name have no semantic meaning.

---

## Who/what uses Docker?

- [dsub](https://github.com/DataBiosphere/dsub)
- [Google CoLab](https://colab.research.google.com/drive/1zlsj8PKU2zj8Prx8W-nyHUd6b0UDtJ03)
- [MyBinder](https://github.com/rwcitek/MyBinder.demo/blob/main/Regular.Expressions/wordle.bash.ipynb)

---

## dsub

## How to convert 10,000 images ...
... in under 7 months.

[10k images](https://rwcitek.github.io/data.science/slides/data_science/#/2)

---

## dsub

{ demo }

---

## Best Practices
DO:
- create snapshots (commit) often while working in an interactive container
- turn your history from the interactive container into a Dockerfile
- pass passwords into containers via run-time options or a mounted volumes

---

## Best Practices
DO NOT:
- push snapshot images to registry ( build with a Dockerfile )
- put credentials in your Dockerfile or image
- use an ENV file with docker-compose:
  - good idea, poorly implemented

---

## Summary

- Use cases
- Common "modes"
- Why?
- Docker objects and commands
- Registry
- Workflow
- Best Practices
- Who uses Docker

---

## References
- [Official docs](https://docs.docker.com/get-started/)
- [O'Reilly Learning Lab](https://learning.oreilly.com/topics/docker/)

---

## Future topics

- Docker: Volumes, Networking, Secrets, Compose, Swarm, ...

- [Networks](https://success.docker.com/article/networking#userdefinedbridgenetworks)

- [Containers vs Virtual machines](https://docs.docker.com/get-started#containers-and-virtual-machines)

- [Kubernetes](https://kubernetes.io/)

- Philosophy
  - [Cattle vs pets](http://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/#understanding-pets-and-cattle)


<hr />

- Markdown initially written with [StackEdit](https://stackedit.io/).
- Diagrams with [DrawIO](https://www.draw.io/).
- This presentation in [GitHub Pages](https://github.com/rwcitek/docker/tree/gh-pages)
- This project repo in [GitHub](https://github.com/rwcitek/docker/blob/gh-pages/_slides/DockerGentleIntro.md)


