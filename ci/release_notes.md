## BBL ([bosh-bootloader](https://github.com/cloudfoundry/bosh-bootloader)) Support
In this release initial support for BBL has been added, currently only AWS, GCP and Azure are supported.
By combining BUCC and BBL you will get the whole BUCC stack with loadbalancer and valid cloud-config.
So you can directly start deploying bosh releases with concourse.
Usage instructions can be found [here](https://github.com/starkandwayne/bucc/tree/master/bbl).

## Breaking: All bucc state dir related envrionment variables are now capitalized
In an effort to formalize the bucc state related enviorment variables we removed support for lowercase variables.
The following variables are supported going forward:

```
BUCC_PROJECT_ROOT: defaults to the bucc repo root
BUCC_STATE_ROOT: defaults to BUCC_PROJECT_ROOT/state
BUCC_VARS_FILE: defaults to BUCC_PROJECT_ROOT/vars.yml
BUCC_STATE_STORE: defaults to BUCC_STATE_ROOT/state.json
BUCC_VARS_STORE: defaults to BUCC_STATE_ROOT/creds.yml
```

### Bug fixes:
- Fixed issue where concourse baggageclaim was using only fraction of available disk [details](https://github.com/starkandwayne/bucc/issues/126).

### Small improvments
- The BBL related refactoring also resulted in some performance improvements to the bucc-cli
- Added OpenStack --floating-ip flag (thanks @jyriok)
- Added global --concourse-lb flag
- Fix bucc ssh with arguments
- Fix example GCP zone (thanks @daniellavoie)
