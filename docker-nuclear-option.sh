#!/bin/bash -e

warning_count=0

function check() {
  local really
  really="$1"
  warning_count=$((warning_count + 1))

  echo "---------------------------- WARNING! ($warning_count of 3) ----------------------------"
  echo ""

  if [ "$(uname)" = 'Darwin' ] ; then
    echo "This will ${really}delete all your local Docker images, volumes, and VM image."
  else
    echo "This will ${really}delete all your local Docker images and volumes."
  fi

  echo ""

  read -p "Are you ${really}sure? [y/N]: " sure
  echo ""

  # Convert to lower case
  sure=$(echo "$sure" | tr '[:upper:]' '[:lower:]')

  if [ "$sure" != "y" ] ; then
    exit
  fi
}

# Be VERY sure...
check ""
check "really "
check "really, really "

docker system prune --all --volumes --force

if [ "$(uname)" = 'Darwin' ] ; then
  vm_dir=$HOME/Library/Containers/com.docker.docker/Data/vms

  find "$vm_dir" -name Docker.raw | while read -r image_file ; do
    rm -f "$image_file"
    echo "Deleted $image_file"
  done

  killall Docker
  open /Applications/Docker.app

  echo "Restarted Docker"
fi
