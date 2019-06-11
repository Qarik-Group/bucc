## Concourse 5 (5.3.0 to be precise)
It took way longer then anticipated but we are finally able to ship Concourse 5.
Due to the way Concourse 5 embeds garden (incompatible with the garden cpi),
we where forced to make a PR [concourse/3806](https://github.com/concourse/concourse/pull/3806) to restore the ability to use an external garden daemon.

## Docker Desktop support
This release adds support for [Docker Desktop](https://www.docker.com/products/docker-desktop), giving people developing locally a solid alternative for the `virtualbox` cpi.
To use it, just run:
```
bucc up --cpi docker-desktop --lite
```

### Bug fixes:
- [bbl] fixed Azure rule conflicts (thanks @warroyo)
- Improved README (thanks @dashaun)
- CREDHUB_SERVER is now correctly set by `bucc env`
