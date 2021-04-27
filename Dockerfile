# TODO: Is it necessary to enable Alpine Community Repository for gRPC lib?
# If so is it necessary in build, release or both? Should see what script
# parameters can be pulled out as ARGs.
ARG MIX_ENV=prod
ARG PROTO_DIR=./priv/proto



################################################################
#                          BUILD STAGE                         #
################################################################
# Build stage defines the base dependencies for building the   #
# project, be it for development or production. Project files  #
# are not mounted in, for reasoning see dev stage comments.    #
################################################################
FROM elixir:alpine AS build
ARG MIX_ENV
ARG PROTO_DIR

ENV MIX_ENV=${MIX_ENV}

# By convention, /opt is typically used for applications
RUN mkdir -p /opt/app
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
      git \
      protobuf \
      build-base \
      postgresql-client

RUN mix local.rebar --force && \
    mix local.hex --force && \
    mix escript.install --force hex protobuf

# Fetch dependencies and compile
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

################################################################
#                          DEV STAGE                           #
################################################################
# Dev image does not copy in any of the project files. It is   #
# meant to only provide an development container into which    #
# the project may be mounted to from the host environment.     #
# This stage is separate from the build stage as it may be     #
# desirable to have development dependencies which are         #
# separate from the general project build requirements.        #
################################################################
FROM build AS dev
ARG MIX_ENV

ENV MIX_ENV=${MIX_ENV}
# Add escripts path for convenience.
ENV PATH="/root/.mix/escripts/:${PATH}"

# This step installs all the build tools we'll need
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
      openssh-client

WORKDIR /opt/app

# Mix is available, so use Mix task to start gRPC server.
CMD ["mix", "grpc.server"]

################################################################
#                     RELEASE STAGE                            #
################################################################
# Release stage copies in project files for building Mix       #
# release packages. The release package is then copied over    #
# into a clean image in the prod stage.                        #
################################################################
FROM build AS release
ARG MIX_ENV
ENV MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

COPY . ./

# Generate protofiles. Set path for command only as it is a one-off use.
RUN PATH=/root/.mix/escripts/:${PATH} mix proto.build

RUN mix release

################################################################
#                     PROD STAGE                               #
################################################################
# Production image. Mix release package is copied over from    #
# the release stage. Elixir/Erlang system dependencies must be #
# installed due to base being a clean alpine image.            #
################################################################
FROM alpine:latest AS prod
ARG MIX_ENV
ENV MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    ncurses-dev \
    openssl \
    unixodbc \
    postgresql-client

# Copy over mix release from build image. This will include the
# Erlang/OTP runtime and compiled project modules.
COPY --from=release /opt/app/_build/${MIX_ENV}/rel/grpc_uploader .

# Run release script
CMD ["bin/grpc_uploader", "start"]
