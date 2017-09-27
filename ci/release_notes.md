# Concourse-Credhub integration
Credential Lookup Rules

When resolving a parameter such as ((foo_param)), it will look in the following paths, in order:

```
/concourse/main/PIPELINE_NAME/foo_param
/concourse/main/foo_param
```
for more details see the [concourse documentation](http://concourse.ci/creds.html#credhub)

# Credhub-importer
With the added [Credhub-importer](https://github.com/cloudfoundry-community/credhub-importer-boshrelease) the following credentials are pre-populated in Credhub:

###### BOSH
- concourse/main/bosh_name
- concourse/main/bosh_environment
- concourse/main/bosh_ca_cert
- concourse/main/bosh_client_secret
- concourse/main/bosh_client

###### Credhub
- concourse/main/credhub_url
- concourse/main/credhub_username
- concourse/main/credhub_password
- concourse/main/credhub_ca_cert

###### Concourse
- concourse/main/concourse_url
- concourse/main/concourse_username
- concourse/main/concourse_password
- concourse/main/concourse_ca_cert
