# a Docker instance as me

## Create the Docker instance
```
docker run \
-v /etc:/host/etc/:ro \
-v /home:/home \
--name ubuntu.${USER} \
ubuntu:18.04 bash -c "
  fgrep -w $USER /host/etc/passwd >> /etc/passwd 
  fgrep -w $USER /host/etc/shadow >> /etc/shadow 
  fgrep -w $USER /host/etc/group >> /etc/group
  sleep 10000d
" &
```
## Install my favorite tools
```
docker exec -it ubuntu.${USER} /bin/bash -c '
  apt-get update &&
    apt-get install -y git less tree vim
'
```
## Run the container as me
```
docker exec -it -u $USER ubuntu.${USER} /bin/bash -l
```
