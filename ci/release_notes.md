## Director bosh-dns
Support for bosh-dns from the bucc VM itself has been added.
This can be used for example to point to a syslog endpoint which still needs to be deployed.
It has been implemented via [a process](https://github.com/starkandwayne/director-bosh-dns-release) which uses fsnotify to watch the director blobstore for dns updates.
These records are then propagated into the vanilla bosh-dns process.

### Bug fixes:
- docker cpi: credhub, concourse and vault proxy ports are now forwarded (thanks @bodymindarts)
- fixed issue where bucc up won't work if there was a `@` in the path (thanks @bodymindarts) [163](https://github.com/starkandwayne/bucc/pull/163)
- thanks @matthewcosgrove for fixing a typo [166](https://github.com/starkandwayne/bucc/pull/166)
- thanks @mogul for fixing a b0rked word [170](https://github.com/starkandwayne/bucc/pull/170)
- UAA users with concourse.main scope can now login to concourse main team
- Update fly if version does not match the release
- Don't cache unsupported flags
- Added --recreate support to bucc up
- Concourse workers are marked as `ephemeral` which fixes [28](https://github.com/starkandwayne/bucc/issues/28)

### Small improvements:
- Added Virtualbox `--remote` flag (thanks @bodymindarts)
- Added `--concourse-syslog` flag
- Added `--ldap` flag
- Added `/concourse/main/default_ca` to credhub can be used to sign concourse lb certs
- Added `--internal-ip` flag to `bucc {info,fly}` to target concourse when lb is down
- Added `bucc rotate-certs` which regenerates all bucc ssl certificates
- Switch to postgres bbr in favor of director/uaa/credhub/atc bbr jobs
