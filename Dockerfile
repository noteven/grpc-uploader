# TODO: Is it necessary to enable Alpine Community Repository for gRPC lib?
# If so is it necessary in build, release or both? Should see what script
# parameters can be pulled out as ARGs.
ARG MIX_ENV=prod
ARG PROTO_DIR=./priv/proto

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
      build-base && \
    mix local.rebar --force && \
    mix local.hex --force && \
    mix escript.install --force hex protobuf


# Fetch dependencies and compile
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Build Release
COPY . .

# Create protobuffer files
RUN PROJ_ROOT=$(pwd) cd ${PROTO_DIR} && \
    PATH=~/.mix/escripts/:$PATH protoc --elixir_out=plugins=grpc:${PROJ_ROOT}/lib/ *.proto

# Release
RUN mix release

# Release image
FROM alpine:latest AS releases
ARG MIX_ENV

# This step installs all the build tools we'll need
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    ncurses-dev \
    openssl \
    unixodbc

# Copy over dependencies and protobuffer files from build
COPY --from=build /opt/app/_build/${MIX_ENV}/rel/grpc_uploader .

CMD ["bin/grpc_uploader", "start"]
