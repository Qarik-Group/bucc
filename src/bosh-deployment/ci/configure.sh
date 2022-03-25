#!/usr/bin/env bash

set -eu

lpass ls > /dev/null

fly -t bosh-ecosystem set-pipeline -p bosh-deployment \
    -c ci/pipeline.yml \
    -l <(lpass show -G "bosh-deployment concourse secrets" --notes) \
    -l <(lpass show --note "concourse:production pipeline:compiled-releases")
