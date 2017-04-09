# BUCC Lite

A lite development env for BUCC (BOSH, UAA Credhub and Concourse)

## Install BUCC Lite

### Prepare the Environment

1. Check that your machine has at least 8GB RAM, and 100GB free disk space. Smaller configurations may work.

2. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Known working version:

```
$ VBoxManage --version
  5.1...
```

Note: If you encounter problems with VirtualBox networking try installing [Oracle VM VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads) as suggested by [Issue 202](https://github.com/cloudfoundry/bosh-lite/issues/202). Alternatively make sure you are on VirtualBox 5.1+ since previous versions had a [network connectivity bug](https://github.com/concourse/concourse-lite/issues/9).
    
3. Install [BOSH CLI v2.0.1+](https://bosh.io/docs/cli-v2.html)

4. Optionall install [`direnv`](https://direnv.net/)

5. Clone this repository

```
git clone https://github.com/starkandwayne/bucc.git
cd bucc
git submodule update --init
```

### Boot your BUCC Lite VM

From the repo root run:
```
$ bucc up
```

To delete your VM run:
```
$ bucc down
```

## Using BUCC Lite

### Using BOSH

```
$ source <(bucc env) # should not be necessary when using direnv

$ bosh alias-env bucc
  Using environment '192.168.50.6' as client 'admin'

  Name      Bosh Lite Director
  UUID      3e107016-3fc2-40af-8ac5-8e53025d53f3
  Version   260.5.0 (00000000)
  CPI       virtualbox_cpi
  Features  compiled_package_cache: disabled
            dns: disabled
            snapshots: disabled
  User      admin

  Succeeded
  
$ bosh vms
  Using environment '192.168.50.6' as client 'admin'

  Succeeded
```

### Using UAA

1. Install the cli

```
gem install cf-uaac
```

2. Use UAA

```
$ bucc uaac

  Target: https://192.168.50.6:8443
  Context: uaa_admin, from client uaa_admin


  Successfully fetched token via client credentials grant.
  Target: https://192.168.50.6:8443
  Context: uaa_admin, from client uaa_admin

$ uaac client get admin
  scope: uaa.none
  client_id: admin
  resource_ids: none
  authorized_grant_types: client_credentials
  autoapprove:
  authorities: bosh.admin
  lastmodified: 1490280436993
```

### Using Credhub

1. Install the cli

```
curl -s -L 'https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/0.5.1/credhub-linux-0.5.1.tgz' | tar -xz # Linux
curl -s -L 'https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/0.5.1/credhub-darwin-0.5.1.tgz' | tar -xz # OSX
mv credhub /usr/local/bin
```

2. Use Credhub

```
$ bucc credhub
  Warning: The targeted TLS certificate has not been verified for this connection.
  Setting the target url: https://192.168.50.6:8844
  Login Successful

$ credhub generate --name test
  Type:          password
  Name:          /test
  Value:         Nfjbu0HKKI9eHmbGY6hNLjssDphpdO
  Updated:       2017-03-23T14:49:03Z
```

### Using Concourse

#### Via the GUI

To get the login details for your consoure GUI run:

```
bucc info
```


#### With Fly

1. Install the fly cli:

```
wget --no-check-certificate 'https://192.168.50.6/api/v1/cli?arch=amd64&platform=darwin' -O fly # OSX
wget --no-check-certificate 'https://192.168.50.6/api/v1/cli?arch=amd64&platform=linux' -O fly  # Linux

chmod +x fly
mv fly /usr/local/bin
```

2. Use Fly

```
$ bucc fly

  target saved

$ fly -t bucc pipelines
  name  paused  public
```




