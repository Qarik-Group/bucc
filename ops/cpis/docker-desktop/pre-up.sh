#!/bin/bash -e

network=$(bosh int ${1} --path /network)
subnet=$(bosh int ${1} --path /internal_cidr)

if ! docker network ls | grep -q ${network}; then
    echo "Creating docker network: ${network} with range: ${subnet}"
    docker network create -d bridge --subnet=${subnet} ${network} --attachable 1>/dev/null
else
    echo "Using existing docker network: ${network}"
fi
