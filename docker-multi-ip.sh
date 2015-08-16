#!/bin/sh

for container in `docker ps -a | grep -v "CONTAINER" | awk '{print $NF}'` ; do
  echo "$container: $(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $container)"
done
