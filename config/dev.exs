import Config

# Configure your database
config :grpc_uploader, GRPCUploader.Repo,
  username: "grpc_uploader",
  password: "grpc_uploader",
  database: "grpc_uploader_dev",
  hostname: "localhost",
  port: 5433,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
