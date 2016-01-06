#!/bin/sh

if [ `docker ps -a | grep -v "CONTAINER" | wc -l ` -gt 0 ] ; then
  docker ps -a | grep -v "CONTAINER" | awk '{print $1}' | xargs docker stop
  docker ps -a | grep -v "CONTAINER" | awk '{print $1}' | xargs docker rm
fi
