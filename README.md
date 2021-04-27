# grpc-uploader

**TODO: Add description**

### System Dependencies
This project depends on [elixir-protobuf](https://github.com/elixir-protobuf/protobuf) and [elixir-grpc](https://github.com/elixir-grpc/grpc).

`protoc` may be installed by downloading a release from [Github](https://github.com/protocolbuffers/protobuf/releases/) and adding it to the PATH, or from ones system package manager (refer to systems documentation as appropriate). Afterwards, run the following command to install the `protoc-gen-elixir` extension for `protoc`.
```
mix escript.install hex protobuf
```

## Installation
Installation only requires the use of mix as follows:
```
mix escript.install hex protobuf
PATH=~/.mix/escripts:$PATH mix setup
```
To begin the server run:
```
mix grpc.server
```
## Using Docker-Compose

Before running the respective docker-compose commands below, ensure that the necessary
environment variables are set, as defined in `config/runtime.exs`.

For the development environment, simply copy `.env.example` to `.env` and set the values
as desired. For production, environment variables may be set by providing the appropriate
definitions in `docker-compose.prod.yml` or by providing them through the command-line
through the `-e` flag.

**NOTE:** Local environment variables override those found in .env or passed by flags.

### Development
It should be noted that starting the development environment requires settings the
`UID` and `GID` environment variables. This is due to the fact that mounting the project from the host into the container may lead to file access errors, due to mismatched permissions between host and container otherwise.

```
UID=$(id -u) GID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

To automatically provision SSH keys into the container, please view the
### Production
```
docker-compose -e ... -f docker-compose.yml -f docker-compose.prod.yml up
```

## Using VSCode development containers

Support for utilizing `ms-vscode-remote.remote-containers` plugin to attach to a
container for development is provided.

It should be noted that VSCode will automatically provision the developers SSH keys,
_provided that an SSH agent is already running_ with the appropriate keys added. For
more information refer to Microsofts [documentation](https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys).
