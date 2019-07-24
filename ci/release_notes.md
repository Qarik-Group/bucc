## Support for air gaped environments
To use bucc in offline environment, you can now for example run:

```
bucc offline --cpi virtualbox --lite --destination /tmp/offline
# copy /tmp/offline/bucc-*.tgz to your offline envrionment
tar -xf bucc-*.tgz && bucc
./bin/bucc up
```

### Bug fixes:
- `bucc down` now passes on the `bosh` cli exit codes (thanks @benjoyce)
- improved README (thanks @matthewcosgrove)
