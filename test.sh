#!/bin/bash

docker run -it --rm \
       --network=bosh \
       --ip 10.245.0.8 \
       --volume ~/.bosh:/root/.bosh:cached \
       --volume $(pwd):/root/bucc \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       starkandwayne/genesis \
       /root/bucc/bin/bucc up --cpi docker-desktop

# starkandwayne/bucc-docker-desktop \
