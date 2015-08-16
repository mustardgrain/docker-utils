#!/bin/sh

sudo route delete 172.17.0.0/16 `docker-machine ip dev`
