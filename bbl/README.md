# Deploy BUCC with bbl ([bosh-bootloader](https://github.com/cloudfoundry/bosh-bootloader))

Steps to deploy BUCC with bbl:

## Initialize a new bbl environment repo

```
export BBL_IAAS=aws|gcp
export BBL_ENV_NAME=banana-env
mkdir $BBL_ENV_NAME && cd $BBL_ENV_NAME && git init
bbl plan -lb-type concourse
git submodule add https://github.com/starkandwayne/bucc.git bucc
ln -s bucc/bbl/*-director-override.sh .
ln -sr bucc/bbl/terraform/$BBL_IAAS/* terraform/
bbl up
eval "$(bbl print-env)"
eval "$(bucc/bin/bucc env)"
```

## Update bucc

```
git submodule update --remote bucc
bbl up
```

## Usage

Just use bucc [as normal](https://github.com/starkandwayne/bucc#using-bucc).
