# pacto-server

Reverse proxy calls to microservices, logging and generating contract tests.

Can be used to automatically generate a set of contract tests between microservices that can 
then be used in continuous integration to check new versions of microservices conform to the
deployed contracts.

Use case: 
* a set of versions of microservices are currently deployed together
* one or more new microservices need to be deployed, with graceful handover from the old
  to the new versions (i.e. they are mutually API compatible).
* need to validate that currently deployed consumers are compatible with new producers - 
  therefore generate a set of contract tests for currently deployed microservices and 
  validate those contracts against the new set of microservices to verify that they are
  compatible
* Run a pacto-server as a reverse proxy in front of each microservice to automatically generate
  contract tests, then use those contracts with the new versions of the microservices to ensure
  compatibility

## capturing contracts

`PACTO_INSECURE_TLS=true bundle exec pacto-server proxy --port 9000 --to https://localhost:50243 --spy --generate`

Note: contracts will be stored in `./contracts/` by default

## testing/validating contracts

`PACTO_INSECURE_TLS=true bundle exec pacto-server proxy --port 9000 --to https://localhost:50243 --spy --validate`

## results

Find results in `pacto_stenographer.log`

## notes

1. bit of a hack when using ports (contracts are saved without port names, the code in this 
   branch turns off port comparison with a hack - but this means there will be confusion 
   when the same API path is used on multiple microservices.)
