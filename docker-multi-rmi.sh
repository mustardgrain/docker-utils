#!/bin/bash -e

if [ `docker images -a -q | wc -l ` -gt 0 ] ; then
  docker images -a -q | sort | uniq | xargs docker rmi
fi