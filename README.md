# BUCC ([BOSH](http://bosh.io/), [UAA](https://github.com/cloudfoundry/uaa), [Credhub](https://github.com/cloudfoundry-incubator/credhub) and [Concourse](https://concourse-ci.org/)) [![BUCC CI](https://pipes.starkandwayne.com/api/v1/teams/bucc/pipelines/bucc/jobs/integration-test/badge)](https://pipes.starkandwayne.com/teams/bucc/pipelines/bucc)

The bucc command line utility allows for easy bootstrapping of the BUCC stack (Bosh Uaa Credhub and Concourse). Which is the starting point for many deployments.

## Install the bucc-cli

### Prepare the Environment

1. Install [BOSH CLI v2.0.1+](https://bosh.io/docs/cli-v2.html) and [dependencies](https://bosh.io/docs/cli-v2-install/#additional-dependencies).

2. Optionally install [`direnv`](https://direnv.net/)

3. Clone this repository

```
git clone https://github.com/starkandwayne/bucc.git
cd bucc
source .envrc # if not using direnv
```

### Boot your BUCC VM

Choose your cpi:
```
bucc up --help
  --cpi      Cloud provider: [aws, virtualbox, gcp, docker-desktop, softlayer, openstack, azure, docker, vsphere]
  --lite     Created bosh will use the warden cpi with garden runc
  --recreate Recreate VM in deployment, also when there are no changes
  --debug    Show arguments passed to 'bosh create-env'
  --concourse-ca-certs
  --concourse-lb
  --concourse-syslog
  --ldap
  --oauth-providers
  --proxy

  Optional cpi specific flags:
    aws: --auto-assign-public-ip --lb-target-groups --security-groups --spot-instance
    virtualbox: --remote
    gcp: --ephemeral-external-ip --service-account --target-pool
    softlayer: --cpi-dynamic
    openstack: --custom-ca --disk-az --dns --floating-ip --ignore-server-availability-zone --keystone-v2 --ntp --root-disk-size --trusted-certs
    azure: --load-balancer --managed-disks
    docker: --unix-sock
    vsphere: --dns --resource-pool
```

From the repo root run:
```
$ bucc up --lite
```

To delete your VM run:
```
$ bucc down
```

### (Optional) Add a Certificate for Concourse

By default, BUCC will generate self-signed certificates for all components. If you would like to add a true certificate for the Concourse web interface, follow these steps:

1. Generate a certificate with the domain name you wish to use for Concourse. This is easily done with [Let's Encrypt](https://letsencrypt.org/) if you don't have another option.
1. Add a variable to `vars.yml` file with the domain name you chose:
    ```yml
    concourse_domain: concourse.foo.com
    ```
1. Add your certificate to `vars.yml` as follows:
   ```yml
    atc_ssl:
      ca: |
        -----BEGIN CERTIFICATE-----
        ...
        -----END CERTIFICATE-----
      certificate: |
        -----BEGIN CERTIFICATE-----
        ...
        -----END CERTIFICATE-----
      private_key: |
        -----BEGIN PRIVATE KEY-----
        ...
        -----END PRIVATE KEY-----
   ```
1. Add the intermediate certificate to `vars.yml` as follows:
    ```yml
    concourse_ca_certs: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
    ```
1. Run bucc with the flags `--concourse-lb` and `--concourse-ca-certs`

## Using BUCC

### Using BOSH

```
$ source <(bucc env) # should not be necessary when using direnv

$ bosh alias-env bucc
  Using environment '192.168.50.6' as client 'admin'

  Name               bosh
  UUID               94e87b44-a7eb-4b67-a568-52553f87cd6e
  Version            268.6.0 (00000000)
  Director Stemcell  ubuntu-xenial/170.9
  CPI                warden_cpi
  Features           compiled_package_cache: disabled
                     config_server: enabled
                     local_dns: enabled
                     power_dns: disabled
                     snapshots: disabled
  User               admin

  Succeeded

$ bosh vms
  Using environment '192.168.50.6' as client 'admin'

  Succeeded
```

### Using UAA

1. Use UAA

```
$ bucc uaa

  installing uaa cli '0.0.1' into: /Users/dcarter/fun/tryagain/bucc/bin/
  Target set to https://192.168.50.6:8443
  Access token successfully fetched and added to context.

$ uaa get-client admin
  {
    "client_id": "admin",
    "scope": [
      "uaa.none"
    ],
    "resource_ids": [
      "none"
    ],
    "authorized_grant_types": [
      "client_credentials"
    ],
    "authorities": [
      "bosh.admin"
    ],
    "lastModified": 1549969159011 .
  }
```

### Using Credhub

```
$ source <(bucc env) # should not be necessary when using direnv

$ bucc credhub
Setting the target url: https://192.168.50.6:8844
Login Successful

$ credhub api
https://192.168.50.6:8844

$ credhub generate -t password --name test
  id: 63947a28-ee47-4d3c-9320-7972c70ec431
  name: /test
  type: password
  value: <redacted>
  version_created_at: "2019-02-10T13:35:06Z"
```

### Using Concourse

#### Via the GUI

To get the login details for your concourse GUI run:

```
bucc info
```


#### With Fly

```
$ bucc fly

  logging in to team 'main'

  target saved
  Example fly commands:
    fly -t bucc pipelines
    fly -t bucc builds

$ fly -t bucc pipelines
  name  paused  public
```

## Backup & Restore
BUCC works with [BBR](https://github.com/cloudfoundry-incubator/bosh-backup-and-restore).

To make a backup of your deployed BUCC vm, run:

```
bucc bbr backup
```

To recreate your environment from a backup run:

```
cd bucc
last_backup=$(find . -type d -regex ".+_.+Z" | sort -r | head -n1)
tar -xf ${last_backup}/bosh-0-bucc-creds.tar -C state
bucc up # clean BUCC with credentials (creds.yml) from backup
bucc bbr restore --artifact-path=${last_backup}
```

## Support for air-gapped environments
To use bucc in an offline environment run:

```
bucc offline --cpi virtualbox --lite --destination /tmp/offline
# copy /tmp/offline/bucc-*.tgz to your offline envrionment
tar -xf bucc-*.tgz && bucc
./bin/bucc up
```
