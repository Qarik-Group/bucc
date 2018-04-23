# Deploy BUCC with bbl ([bosh-bootloader](https://github.com/cloudfoundry/bosh-bootloader))

Steps to deploy BUCC with bbl:

## Initialize a new bbl environment repo

```
mkdir banana-env && cd banana-env
bbl plan --name banana-env
git submodule add https://github.com/starkandwayne/bucc.git bucc
ln -s bucc/bbl/*-director-override.sh .
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

Just use bucc [as normal](https://github.com/starkandwayne/bucc#using-bucc), only `bucc {up,down,clean}` commands will not work and instead `bbl {up,down}` should be used.
