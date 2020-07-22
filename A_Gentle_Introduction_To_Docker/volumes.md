# Volumes
## Flavors
| Name | FS Type | FS location | State |
| --- | --- | --- | --- |
| instance | overlay | /var/lib/docker/overlay/ | ethereal |
| anonymous | volume | /var/lib/docker/volume/ | ethereal/persistent |
| named | volume | /var/lib/docker/volume/ | persistent |
| mapped | bind | speciefied on host | ethereal/persistent |


### Examples
Create an instance with several volume mounts
```
docker run --rm \
    -v /:/vmroot \
    -v /data1 \
    -v data2 \
    -v data3:/data3 \
    -v /data:/data4 \
    --name vol_example \
    ubuntu:18.04 \
    sleep 10d &
```
Show mounts
```
docker container inspect vol_example |
    jq -S '.[].Mounts[] | { Host_source: .Source, Instance_destination: .Destination }'
```


