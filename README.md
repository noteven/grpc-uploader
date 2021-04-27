# grpc-uploader

**TODO: Add description**

### System Dependencies
This project depends on [elixir-protobuf](https://github.com/elixir-protobuf/protobuf) and [elixir-grpc](https://github.com/elixir-grpc/grpc).

`protoc` may be installed by downloading a release from [Github](https://github.com/protocolbuffers/protobuf/releases/)
and adding it to the PATH, or from ones system package manager (refer to systems documentation as appropriate).
Afterwards, run the following command to install the `protoc-gen-elixir` extension for `protoc`.
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
`UID` and `GID` environment variables. This is due to the fact that mounting the project from
the host into the container may lead to file access errors, due to mismatched permissions between
host and container otherwise.

```
UID=$(id -u) GID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

#### Provisioning SSH Keys
To automatically provision SSH keys into the container, one may edit the `docker-compose.dev.yml`
utilizing one of the following techniques.

##### Docker Secrets
```
    grpc_uploader:
      secrets:
      - user_ssh_key

secrets:
  user_ssh_key:
    file: ~/.ssh/keyfile
```

This method depends on the use of Docker secrets to provision the appropriate ssh_key into the container
and should be preferred. It is worth noting that one must still manually initiate the SSH Aaent and add the
key in the container as follows:

```
eval $(ssh-agent)
ssh-add /run/secrets/user_ssh_key
```

##### Volume Mounts
This method relies on having set-up ssh-agent on the host machine and mounting its socket
into the container. Starting the SSH agent is not necessary, nor is adding the key if it
has already been added beforehand (in the host or elsewhere).
```
    grpc_uploader
      volumes:
        - $SSH_AUTH_SOCK:/ssh-agent # Forward local machine SSH key to docker

environment:
    SSH_AUTH_SOCK: /ssh-agent
```
For automatically starting an SSH agent and setting up the socket file, please view the
Microsoft VSCode documentation linked in [VSCode Development Container](#vscode-development-container).
### Production
```
docker-compose -e ... -f docker-compose.yml -f docker-compose.prod.yml up
```

## VSCode Development Container

Support for utilizing `ms-vscode-remote.remote-containers` plugin to attach to a
container for development is provided.

It should be noted that VSCode will automatically provision the developers SSH keys,
_provided that an SSH agent is already running_ with the appropriate keys added. For
more information refer to Microsofts [documentation](https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys).
