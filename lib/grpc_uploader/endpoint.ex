
  # Define your endpoint
  defmodule GRPCUploader.Endpoint do
    use GRPC.Endpoint

    intercept(GRPC.Logger.Server)
    run(GRPCUploader.API.Server)
  end
