
# Dockerfile for PDFTK

## Summary

This Dockerfile file creates an image that contains the
pdftk package and dependencies.  This allows one to create
a container to manipulate PDFs.

## Example usage
### create an image

docker.image.new.dockerfile --file=Dockerfile --tag=myregistry/pdftk:v01 ./.

### create a container

docker.container.new.image --name="pdftk.v01" -v ${PWD}/:/data myregistry/pdftk:v01 /data/script

### create a script

```
cat <<eof > script
#!/bin/bash
date > /data/date.txt
eof
chmod +x script
```

### start the container

docker.container.start pdftk.v01

### see the results

cat date.txt

### clean up

docker.container.delete pdftk.v01
docker.image.delete myregistry/pdftk:v01

