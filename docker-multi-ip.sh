#!/bin/sh

for container in `docker ps -a -q` ; do
  docker inspect --format '{{ .Name }}: {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container | sed 's/\///'
done
