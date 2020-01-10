#!/bin/bash -e

DOCKER_MEMORY_ERROR_GB=8
DOCKER_FILE_ERROR_GB=64

# Check Docker memory size...
raw_mem_size_in_gb=$(docker info | grep -i "Total Memory" | awk '{ print $3}' | sed 's/GiB//g')
mem_size_in_gb=$(python -c "print int(round(float($raw_mem_size_in_gb)))")

if [ "$mem_size_in_gb" -lt $DOCKER_MEMORY_ERROR_GB ] ; then
  echo "Your Docker memory is too small ($raw_mem_size_in_gb GB), which will likely cause"
  echo "things to break in unexpected ways."
  echo ""
  echo "Please set your memory to at least $DOCKER_MEMORY_ERROR_GB GB, restart Docker and"
  echo "run $(basename "$0") again."

  exit 1
fi

if [ "$(uname)" = 'Darwin' ] ; then
  # Check Docker image size...
  vm_dir=$HOME/Library/Containers/com.docker.docker/Data/vms

  if [ ! -d "$vm_dir" ] ; then
    echo "Could not find Docker image directory $vm_dir"
    exit 2
  fi

  find "$vm_dir" -name Docker.raw | while read -r image_file ; do
    file_size_in_gb=$(($(stat -f "%z" "$image_file") / 1024**3))

    if [ $file_size_in_gb -gt $DOCKER_FILE_ERROR_GB ] ; then
      echo "Your Docker image file is too large ($file_size_in_gb GB), which will likely cause"
      echo "things to break in unexpected ways."
      echo ""
      echo "Please run the following commands to fix the issue:"
      echo ""
      echo "     docker system prune -a -f"
      echo "     rm -f $image_file"
      echo ""
      echo "Then restart Docker and run $(basename "$0") again."
      exit 3
    fi
  done
fi
