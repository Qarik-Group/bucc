## Breaking: All bucc state dir related envrionment variables are now capitalized
In an effort to formalize the bucc state related enviorment variables we removed support for lowercase variables.
The following variables are supported going forward:

```
BUCC_PROJECT_ROOT: defaults to the bucc repo root
BUCC_STATE_ROOT: defaults to BUCC_PROJECT_ROOT/state
BUCC_VARS_FILE: defaults to BUCC_PROJECT_ROOT/vars.yml
BUCC_STATE_STORE: defaults to BUCC_STATE_ROOT/state.json
BUCC_VARS_STORE: defaults to BUCC_STATE_ROOT/creds.yml
```

### Bug fixes:

### Small improvments
