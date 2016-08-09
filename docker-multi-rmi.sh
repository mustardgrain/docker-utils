#!/bin/bash -e

docker images | awk '{ print $3} ' | grep -v "IMAGE" | sort | uniq | xargs docker rmi
