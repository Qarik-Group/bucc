# IMPORTANT Upgrade notice
Because of the following concourse upgrade restrictions:
> If you are currently on a version older than v3.6.0, you must first upgrade to v3.6.0 before upgrading past it!

This means upgrading to BUCC [v0.2.0](https://github.com/starkandwayne/bucc/releases/tag/v0.2.0) before upgrading past it!

## New variables in credhub
- /concourse/main/bosh_cpi
- /concourse/main/bosh_stemcell
- /concourse/main/bosh_ssh_private_key
- /concourse/main/bosh_ssh_username

## Bug fixes
- Fixed issue [where flags where not used](https://github.com/starkandwayne/bucc/commit/c151076c8442a629160bcec4a6bae19167bf024d) in some cases

### Small improvments
- Added `--root-disk-size` flag for OpenStack (for when flavor has no ephemeral disk).
- Crehub cli will be upgraded if version is out of date
