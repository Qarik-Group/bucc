#!/bin/bash

network=$(bosh int ${1} --path /network)

if docker network ls | grep -q ${network}; then
    echo "Removing docker network: ${network}"
    docker network remove ${network} 1>/dev/null
else
    echo "Skipping cleanup: docker network: ${network} does not exist"
fi
