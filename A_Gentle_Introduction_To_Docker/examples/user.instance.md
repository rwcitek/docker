# A Docker instance as me

## Create the Docker instance
```
docker create \
  -v /etc:/host/etc/:ro \
  -v /home:/home \
  --name ubuntu.${USER} \
  ubuntu:18.04 sleep 10000d
```

## Start the Docker instance
```
docker start ubuntu.${USER}
```

## Configure my user account
```
docker exec -it ubuntu.${USER} /bin/bash -c "
  fgrep -w $USER /host/etc/passwd >> /etc/passwd 
  fgrep -w $USER /host/etc/shadow >> /etc/shadow 
  fgrep -w $USER /host/etc/group >> /etc/group
"
```

## Install my favorite tools
```
docker exec -it ubuntu.${USER} /bin/bash -c '
  apt-get update &&
    apt-get install -y git less tree vim
'
```

## Exec into the container as me
```
docker exec -it -u $USER ubuntu.${USER} /bin/bash -l
```







