defmodule GRPCUploader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
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
