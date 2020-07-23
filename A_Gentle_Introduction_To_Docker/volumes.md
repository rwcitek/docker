# Volumes
## Flavors
Volumes come in four flavors:

| Name | FS Type | FS location | State |
| --- | --- | --- | --- |
| instance | overlay | /var/lib/docker/overlay/ | temporary |
| anonymous | native ( volume ) | /var/lib/docker/volume/ | temporary/persistent |
| named | native ( volume ) | /var/lib/docker/volume/ | persistent |
| mapped | native ( bind ) | specified on host | persistent |

Every container instance is automaticaly created with an instance volume that is based on the Docker image from which it is derived.
The other flavors have to be explicitly created.

### Examples
Create an instance with several volume mounts:
```
docker run --rm \
    -v /:/vmroot \
    -v /data1 \
    -v data2 \
    -v data3:/data3 \
    -v /data4:/data4 \
    --name vol_example \
    ubuntu:18.04 \
    sleep 10d &
```

Show instance volume:
```
# volume
docker container inspect vol_example |
  jq -rS '.[].GraphDriver.Data.WorkDir' |
  rev |
  cut -d/ -f2- |
  rev | 
  tee /tmp/volume.instance.list

# contents of volume on host
cat /tmp/volume.instance.list |
  xargs -t -n1 sudo ls -l
```

Show other volumes:
```
# as TSV
{
echo -e 'Instance\tHost\n---\t---'
docker container inspect vol_example |
  jq -r '.[].Mounts[] | [ .Destination, .Source ] | @tsv' |
  sort
} | column -ts$'\t'

# as hash
docker container inspect vol_example |
  jq -S '.[].Mounts[] | { Instance_destination: .Destination, Host_source: .Source }'

# as list
docker container inspect vol_example |
  jq -r '.[].Mounts[].Source' |
  tee /tmp/volume.others.list
```

You can list the contents of the volumes on the host:
```
cat /tmp/volume.others.list |
  xargs -t -n1 sudo ls -ld
```
When the container is removed, most volumes are automatically removed with it.

Stop and kill the container:
```
docker container stop vol_example
```
List the contents of the volumes on the host again.  Notice that some are missing, but some persist.
```
# instance volume is gone
cat /tmp/volume.instance.list |
  xargs -t -n1 sudo ls -l

# list explicit volumes on the host
cat /tmp/volume.others.list |
  xargs -t -n1 sudo ls -ld

# volumes that persist
docker volume list
```
Notice that the ones that persisted are the named volume and any that were mounted from the host.
That is, the anonymous volumes were automatically removed.

### Persistent anonymous volumes
However, there is a way to create persistent anonymous volumes: don't use the `--rm` option:
```
# run the instance
docker run \
    -v /:/vmroot \
    -v /data1 \
    -v data2 \
    -v data3:/data3 \
    -v /data4:/data4 \
    --name vol_example \
    ubuntu:18.04 \
    sleep 10d &

# list the volumes
docker container inspect vol_example |
  jq -r '.[].Mounts[].Source' |
  tee /tmp/volume.others.list

# stop the instance
docker stop vol_example

# remove the instance
docker rm vol_example

# list volumes on the host
cat /tmp/volume.others.list |
  xargs -t -n1 sudo ls -ld

# volumes that persist
docker volume list
```
Notice that all the volumes are still on the host, include the anonymous ones.
You can achieve the same effect by using `docker create ...` instead of `docker run ...`


## Uses
There are four main uses for volumes
1. isolating data
1. sharing data between the host and containers
1. sharing data between containers
1. providing containers access to remote storage

### Isolation

### Host-container sharing

### Between container sharing

### Remote storage
