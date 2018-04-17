# bucc ssh over jumpbox
When using `bucc ssh` it will now pickup `ssh+socks5://` from BOSH_ALL_PROXY.
This makes bucc compatible with the `bbl print-env` output.

## New variables in credhub
- concourse/main/bucc_version

### Bug fixes:
- thanks @drnic for fixing `bucc bosh` [[100]](https://github.com/starkandwayne/bucc/pull/98)
- thanks @martyca for fixing `bucc env` in a directory with a space [[98]](https://github.com/starkandwayne/bucc/pull/98)
- thanks @PhilippeKhalife for fixing `bucc ssh` with command [[106]](https://github.com/starkandwayne/bucc/pull/106)

### Small improvments
- Added AWS `--spot-instance` flag
- Added Azuere `--managed-disks` flag (thanks @bgandon)
