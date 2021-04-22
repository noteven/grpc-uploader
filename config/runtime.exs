# This file is responsible for configuring your application
# and its dependencies at runtime.

# General application configuration
import Config

config :grpc_uploader, GRPCUploader.Repo,
  database: System.fetch_env!("DB_DATABASE"),
  username: System.fetch_env!("DB_USERNAME"),
  password: System.fetch_env!("DB_PASSWORD"),
  hostname: System.fetch_env!("DB_HOST"),
  port: System.fetch_env!("DB_PORT")
