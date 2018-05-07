# Deploy BUCC with bbl ([bosh-bootloader](https://github.com/cloudfoundry/bosh-bootloader))

Steps to deploy BUCC with bbl:

## Initialize a new bbl environment repo

```
mkdir banana-env && cd banana-env && git init
export BBL_IAAS=aws|gcp
bbl plan --name banana-env
git submodule add https://github.com/starkandwayne/bucc.git bucc
ln -s bucc/bbl/*-director-override.sh .
ln -sr bucc/bbl/$BBL_IAAS/terraform/* terraform/
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
