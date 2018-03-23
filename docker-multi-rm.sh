#!/bin/sh

if [ `docker ps -a -q | wc -l ` -gt 0 ] ; then
  docker ps -a -q | xargs docker stop
  docker ps -a -q | xargs docker rm
fi
