#!/bin/bash

set -eu -o pipefail

STEP() { echo ; echo ; echo "==\\" ; echo "===>" "$@" ; echo "==/" ; echo ; }

bosh_deployment="$(cd "$(dirname "${BASH_SOURCE[0]}")"; cd ..; pwd)"
bosh_deployment_sha="$(cd "${bosh_deployment}"; git rev-parse --short HEAD)"

if [ "${PWD##${bosh_deployment}}" != "${PWD}" ] || [ -e virtualbox/create-env.sh ] || [ -e ../virtualbox/create-env.sh ]; then
  echo "It looks like you are running this within the ${bosh_deployment} repository."
  echo "To avoid secrets ending up in this repo, run this from another directory."
  echo

  exit 1
fi

####
STEP "Creating BOSH Director"
####

bosh create-env "${bosh_deployment}/bosh.yml" \
  --state "${PWD}/state.json" \
  --ops-file "${bosh_deployment}/virtualbox/cpi.yml" \
  --ops-file "${bosh_deployment}/virtualbox/outbound-network.yml" \
  --ops-file "${bosh_deployment}/bosh-lite.yml" \
  --ops-file "${bosh_deployment}/uaa.yml" \
  --ops-file "${bosh_deployment}/credhub.yml" \
  --ops-file "${bosh_deployment}/jumpbox-user.yml" \
  --vars-store "${PWD}/creds.yml" \
  --var director_name=bosh-lite \
  --var internal_ip=192.168.56.6 \
  --var internal_gw=192.168.56.1 \
  --var internal_cidr=192.168.56.0/24 \
  --var outbound_network_name=NatNetwork "$@"


####
STEP "Adding Network Routes (sudo is required)"
####

if [ "$(uname)" = "Darwin" ]; then
  sudo route add -net 10.244.0.0/16 192.168.56.6
elif [ "$(uname)" = "Linux" ]; then
  if type ip > /dev/null 2>&1; then
    sudo ip route add 10.244.0.0/16 via 192.168.56.6
  elif type route > /dev/null 2>&1; then
    sudo route add -net 10.244.0.0/16 gw 192.168.56.6
  else
    echo "ERROR adding route"
    exit 1
  fi
fi

####
STEP "Generating .envrc"
####

cat > .envrc <<EOF
export BOSH_ENVIRONMENT=vbox
export BOSH_CA_CERT=\$( bosh interpolate ${PWD}/creds.yml --path /director_ssl/ca )
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=\$( bosh interpolate ${PWD}/creds.yml --path /admin_password )

export CREDHUB_SERVER=https://192.168.56.6:8844
export CREDHUB_CA_CERT="\$( bosh interpolate ${PWD}/creds.yml --path=/credhub_tls/ca )
\$( bosh interpolate ${PWD}/creds.yml --path=/uaa_ssl/ca )"
export CREDHUB_CLIENT=credhub-admin
export CREDHUB_SECRET=\$( bosh interpolate ${PWD}/creds.yml --path=/credhub_admin_client_secret )

EOF
echo "export BOSH_DEPLOYMENT_SHA=${bosh_deployment_sha}" >> .envrc


source .envrc

echo Succeeded


####
STEP "Configuring Environment Alias"
####

bosh \
  --environment 192.168.56.6 \
  --ca-cert <( bosh interpolate "${PWD}/creds.yml" --path /director_ssl/ca ) \
  alias-env vbox


####
STEP "Updating Cloud Config"
####

bosh -n update-cloud-config "${bosh_deployment}/warden/cloud-config.yml" \
  > /dev/null

echo Succeeded

####
STEP "Updating Runtime Config"
####

bosh -n update-runtime-config "${bosh_deployment}/runtime-configs/dns.yml" \
  > /dev/null

echo Succeeded

####
STEP "Completed"
####

echo "Credentials for your environment have been generated and stored in creds.yml."
echo "Details about the state of your VM have been stored in state.json."
echo "You should keep these files for future updates and to destroy your environment."
echo
echo "BOSH Director is now running. You may need to run the following before using bosh commands:"
echo
echo "    source .envrc"
echo
