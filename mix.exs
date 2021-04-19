defmodule GRPCUploader.MixProject do
  use Mix.Project

  def project do
    [
      app: :grpc_uploader,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        flags: [:unmatched_returns, :error_handling, :race_conditions, :no_opaque, :underspecs, :unknown],
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GRPCUploader.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Protobuf/GRPC
      {:protobuf, "~> 0.7.1"},
      {:google_protos, "~> 0.1"},
      {:grpc, github: "elixir-grpc/grpc"},
      {:cowlib, "~> 2.9.0", override: true},

      # Datasource
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},

      # Project tooling
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "deps.compile", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      check: ["format", "deps.unlock --check-unused", "credo", "dialyzer --quiet --format dialyxir"]
    ]
  end
end
