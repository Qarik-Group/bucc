# PostgreSQL upgrade to v9.6.4
This is a hard requirement for [Concourse v3.6.0](https://concourse.ci/downloads.html#v3.6.0).
The upgrade should be fully automatic and uses [this release](https://github.com/rkoster/migrate-postgres-boshrelease) to migrate from [bosh postgres](https://github.com/cloudfoundry/bosh/tree/master/jobs/postgres-9.4) to [cloudfoundry postgres](https://github.com/cloudfoundry/postgres-release).

To make sure this upgrade works as expected we have added [upgrade tests to the ci pipeline](https://ci.starkandwayne.com/teams/main/pipelines/bucc/jobs/upgrade-test/builds/30). These tests will verify we can upgrade from the latest stable release without losing data. We have seen it fail twice but verified no data was lost and a subsequent `bucc up` finished the migration in both cases.

So to upgrade just run:
```
cd bucc
git pull origin master
git checkout v0.2.0
bucc up
bucc up # when the first bucc up fails with pre-start postgres
```

# Global proxy flag
For all the people using bucc behind a proxy there is now a flag for that:
```
echo "http_proxy: ${HTTP_PROXY}" >> vars.yml
echo "https_proxy: ${HTTP_PROXY}" >> vars.yml
echo "no_proxy: ${NO_RPOXY}" >> vars.yml
bucc up --proxy
```

# Small improvements
- Added OpenStack flags: custom-ca, ignore-server-availability-zone, disk-az  and trusted-certs
- Concourse is now configured with UAA authentication enabled [#61](https://github.com/starkandwayne/bucc/pull/61)
- Added `--debug` flag to `bucc up` which shows all arguments passed to `bosh create-env`
- Improved flag caching, also used flags are shown when doing `bucc up`
- Added `--oauth-providers` which allows configuring [UAA oauth identity providers](https://github.com/cloudfoundry/uaa-release/blob/v52.2/jobs/uaa/spec#L791-L846)