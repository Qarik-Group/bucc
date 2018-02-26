## BBR (BOSH Backup and Restore) support for Disaster Recovery
BUCC is now fully compatible with [BBR](https://github.com/cloudfoundry-incubator/bosh-backup-and-restore).
As part of this feature full [Disaster Recovery testing](https://ci.starkandwayne.com/teams/main/pipelines/bucc/jobs/disaster-recovery-test) has been added to the BUCC ci pipeline.

To make a backup of you deployed BUCC vm, run:

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

## New variables in credhub
- concourse/main/concourse_tsa_host
- concourse/main/concourse_tsa_host_key
- concourse/main/concourse_worker_key

## Bug fixes
- OpenStack `--ntp` flag now correctly sets bosh director ntp (thanks @nouseforaname)
- Using `--cpi=` now correctly sets cpi #76

### Small improvments
- bucc will now install and manage bosh cli
