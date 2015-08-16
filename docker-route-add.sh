#!/bin/sh

sudo route -n add 172.17.0.0/16 `docker-machine ip dev`
