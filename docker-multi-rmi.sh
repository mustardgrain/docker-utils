#!/bin/bash -e

docker images -q | sort | uniq | xargs docker rmi
