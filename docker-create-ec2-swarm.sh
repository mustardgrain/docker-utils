#!/bin/bash -e

if [ $# = 0 ] ; then
  echo "Usage: <swarm name> group1=count group2=count . . ."
  exit 1
fi

token=$(docker run swarm create)
swarm_name=$1
shift

log_dir=/tmp/swarm-${swarm_name}-create
rm -rf $log_dir
mkdir -p $log_dir

echo "Creating $swarm_name"
nohup docker-machine create \
                          --driver amazonec2 \
                          --swarm \
                          --swarm-master \
                          --swarm-discovery=token://$token \
                          $swarm_name > $log_dir/$swarm_name.txt 2>&1 &

for i in "$@"; do
  group=`echo $i | awk -F = '{ print $1 }'`
  count=`echo $i | awk -F = '{ print $2 }'`

  for j in `seq 1 $count`; do
    node_name="${group}-$j"
    echo "Creating $node_name"
    nohup docker-machine create \
                              --driver amazonec2 \
                              --swarm \
                              --swarm-discovery=token://$token \
                              $node_name > $log_dir/$node_name.txt 2>&1 &
  done
done

echo "Waiting for instances to be created"
wait

echo "Waiting for instances to join the swarm"
sleep 30

echo "Swarm details:"
eval "$(docker-machine env --swarm $swarm_name)"
docker info
