#!/bin/bash -e

if [ $# = 0 ] ; then
  echo "Usage: $0 <machine name>"
  exit 1
fi

machine_name=$1

docker-machine create --driver amazonec2 $machine_name
