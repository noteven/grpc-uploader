defmodule GRPCUploader.API.Server do
  @moduledoc false
  use GRPC.Server, service: GRPCUploader.API.Service

  @spec create_token(GRPCUploader.TokenRequest, GRPC.Server.Stream.t()) ::
          GRPCUploader.TokenReponse.t()
  def create_token(request, _stream) do
  end

  @spec claim_token(GRPCUploader.ClaimRequest.t(), GRPC.Server.Stream.t()) ::
          GRPCUploader.ClaimResponse.t()
  def claim_token(request, _stream) do
  end

  @spec authenticate(GRPCUploader.AuthRequest.t(), GRPC.Server.Stream.t()) ::
          GRPCUploader.AuthResponse.t()
  def authenticate(request, _stream) do
  end
end
