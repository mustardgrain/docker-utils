#!/bin/bash -e

if [ $# = 0 ] ; then
  echo "Usage: machine1 [machine2] . . ."
  exit 1
fi

LOG_DIR=/tmp/ec2-cluster-create-logs
rm -rf $LOG_DIR
mkdir -p $LOG_DIR

for machine_name in "$@"; do
    echo "Creating $machine_name"
    nohup docker-machine create \
                         --driver amazonec2 \
                         $machine_name > $LOG_DIR/$machine_name.txt 2>&1 &
  done
done

echo -n "Waiting for instances to be created..."
wait
echo "done"
