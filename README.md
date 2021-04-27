# grpc-uploader

**TODO: Add description**

## Installation

## Using Docker-Compose

Before running the respective docker-compose commands below, ensure that the necessary
environment variables are set, as defined in `config/runtime.exs`.

For the development environment, simply copy `.env.example` to `.env` and set the values
as desired. For production, environment variables may be set by providing the appropriate
definitions in `docker-compose.prod.yml` or by providing them through the command-line
through the `-e` flag.

It should be noted that starting the development environment requires settings the
`UID` and `GID` environment variables, the production environment however does not.
This is due to the fact that the development environment is meant to be used
by mounting the project from the host into the container, and thus matching user
identification is necessary to prevent file access errors due to mismatched
permissions. The same does not hold for the production environment.

NOTE: Local environment variables override those found in .env or passed by flags.

Development:
```
UID=$(id -u) GID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```
Production:
```
docker-compose -e ... -f docker-compose.yml -f docker-compose.prod.yml up
```
