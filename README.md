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

NOTE: Local environment variables override those found in .env or passed by flags.

Development:
```
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```
Production:
```
docker-compose -e ... -f docker-compose.yml -f docker-compose.prod.yml up
```
