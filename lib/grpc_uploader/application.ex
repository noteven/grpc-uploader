defmodule GRPCUploader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

# Define your endpoint
defmodule GRPCUploader.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Logger.Server
  run GRPCUploader.API.Server
end

  @impl true
  def start(_type, _args) do
    children = [
      {GRPC.Server.Supervisor, {GRPCUploader.Endpoint, 4000}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GRPCUploader.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
