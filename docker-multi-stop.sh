#!/bin/sh

docker ps -a | grep -v "CONTAINER" | awk '{print $1}' | xargs docker stop
