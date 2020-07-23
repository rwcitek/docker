# Volumes
## Flavors
| Name | FS Type | FS location | State |
| --- | --- | --- | --- |
| instance | overlay | /var/lib/docker/overlay/ | temporary |
| anonymous | volume | /var/lib/docker/volume/ | temporary/persistent |
| named | volume | /var/lib/docker/volume/ | persistent |
| mapped | bind | speciefied on host | persistent |


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
Show mounts:
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
  tee /tmp/mounts.list
```
You can list the contents of the volumes on the host:
```
cat /tmp/mounts.list |
  xargs -t -n1 sudo ls -ld
```
When the container is removed, most volumes are automatically removed with it.

Stop and kill the container:
```
docker container stop vol_example
```
List the contents of the volumes on the host again.  Notice that some are missing, but some persist.
```
# list volumes on the host
cat /tmp/mounts.list |
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
  tee /tmp/mounts.list

# stop the instance
docker stop vol_example

# remove the instance
docker rm vol_example

# list volumes on the host
cat /tmp/mounts.list |
  xargs -t -n1 sudo ls -ld

# volumes that persist
docker volume list
```
Notice that all the volumes are still on the host, include the anonymous ones.
You can achieve the same effect by using `docker create ...` instead of `docker run ...`

