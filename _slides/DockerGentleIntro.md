---
title: Gentle Intro to Docker
description: Introducing Docker
theme: black
---

# Docker!

This presentation will show you examples of what it can do.

![Docker](https://avatars.githubusercontent.com/u/5429470?s=200&v=4)

{[Slides here](https://rwcitek.github.io/docker/slides/DockerGentleIntro/#/)}

----

## Roadmap
- Use cases
- Common "modes"
- Docker objects and commands
- Registry
- Workflow
- Best Practices
- Who uses Docker


---

## Preamble
- Ask lots of questions
- Don't believe everything I say
	1. Docker is a fast moving target.  What is true now will likely change ... soon.
	2. I misspeak. Left instead of right, up instead of down, etc.
	3. My environment is likely different than yours.  Versions, OS, platforms all matter.
- Call me on it when something doesn't sound right.

----

## What is it? 
![Red Paperclip](https://upload.wikimedia.org/wikipedia/commons/1/1c/One_red_paperclip.jpg)

----

## What you can do with it?
![Red Paperclip](https://upload.wikimedia.org/wikipedia/commons/1/1c/One_red_paperclip.jpg)


[Trade for a house?](https://en.wikipedia.org/wiki/One_red_paperclip)

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

```bash
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

```bash
$ echo 'Hello, world!' |
  docker run --rm -i rwcitek/barcode-gen \
    qrencode --type=PNG --level=H -o - \
  > hello-world.qrcode.png

```

<img src="../../public/hello-world.qrcode.png" alt="slide" width="400"/>

---

## Single command

Decode the QR code

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

Run Ubuntu, Fedora, Slackware, etc.

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

For example, the nginx web server

```bash
$ docker run -d --name nginx -p 8080:80 nginx

$ elinks --dump http://127.0.0.1:8080 | head -3
```
```
                               Welcome to nginx!

   If you see this page, the nginx web server is successfully installed and
   working. Further configuration is required.
...

```

---

## Service

[http://penguin.linux.test:8080/](http://localhost:8080/)

---

## Objects in a Docker Environment

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
  - **U**pdate - change state (pause, stop, start, kill)
  - **D**elete - rm
 
---

## What actions CANNOT be performed on a container instance?

- create container from a container
  - instead: create image and then create container
- modify CPU, RAM, Volumes, Network
  - instead: launch new container with new options

---

## Workflow

1. Run an instance as a service ( -d )
1. Exec into the instance
1. Modify the instance
1. Exit the instance
1. Commit the instance to an image
1. Repeat from step 2
1. Convert command history into a Dockerfile
1. Test the Dockerfile
1. Push to registry


----

## Workflow

{ Demo }

---

## How to get an image: Registry, Repository, local cache
* Registry > Repository > Tag > Image
* A Registry is a host that contains a collection of Repositories.
  * If a Registry is not specified, `dockerhub.com` is the default
* A Repository contains a collection of tagged images.
* A Tag is an identifier for an Image.  An Image can have multiple tags. 
* An Image is specified by the unique combination of a Repository and Tag and is identified by its Image ID.
  * If a Tag is not specified in a pull request, `:latest` is the default

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

## Building an image with a Dockerfile
A Dockerfile is a collection of commands used to build an image

```bash
cat <<'eof' > Dockerfile
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y man-db vim tree less net-tools \
      elinks tidy procps nmap curl telnet iputils-ping \
      dnsutils iproute2 traceroute jq git rsync
COPY Dockerfile /
eof

docker build --tag nettools .

docker run --rm nettools \
  curl -L -s -I google.com
```
---

## Building an image with an Here-Doc Dockerfile
```bash
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

- [Containers vs Virtual machines](https://docs.docker.com/get-started#containers-and-virtual-machines)

- [Networks](https://success.docker.com/article/networking#userdefinedbridgenetworks)

- [Kubernetes](https://kubernetes.io/)

- Philosophy
  - [Cattle vs pets](http://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/#understanding-pets-and-cattle)


<hr />

- Markdown written with [StackEdit](https://stackedit.io/).
- Diagrams with [DrawIO](https://www.draw.io/).
- This presentation in [GitHub Pages](https://github.com/rwcitek/docker/tree/gh-pages)
- This project repo in [GitHub](https://github.com/rwcitek/docker/blob/gh-pages/_slides/DockerGentleIntro.md)


