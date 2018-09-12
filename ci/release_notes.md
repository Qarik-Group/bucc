### Breaking Changes:
if you use multiple teams with different auth systems, it can break your auth to concourse
because we upgraded to Concourse to 4.x and they complety reworked there auth systems.
please check the release notes, https://concourse-ci.org/download.html#v400

### Mayor Improvments
- Switched to Xenial stemcell
- Upgraded to Concourse 4.x.
- switched to bpm for container management

### Small Improvments:
- Switched back to btrfs for the containers
- Removed bucc-bbr job because it is fixed in upstream bosh-deployment repo
- unset all bosh envs when running `bucc clean`
- added check if internet connection is available thanks to @teancom
- added uaa go cli
- showing concourse on uaa homepage
- add user defined certs thanks to @fenech

### Bug fixes:
