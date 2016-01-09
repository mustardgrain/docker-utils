#!/bin/sh

if [ `docker-machine ls | grep -v "DRIVER" | wc -l ` -gt 0 ] ; then
  docker-machine ls | grep -v "DRIVER" | awk '{ print $1 }' | xargs docker-machine rm -y
fi
