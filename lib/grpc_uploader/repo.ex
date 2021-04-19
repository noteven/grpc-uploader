defmodule GRPCUploader.Repo do
  use Ecto.Repo,
    otp_app: :grpc_uploader,
    adapter: Ecto.Adapters.Postgres
end
