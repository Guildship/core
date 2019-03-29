defmodule Guildship.Umbrella.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :guildship,
      version: "1.0.0",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test]
    ]
  end

  def application do
    [
      mod: {Guildship.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "priv/tasks"]

  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:hashids, "~> 2.0"},
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:absinthe, "1.5.0-alpha.4", override: true},
      {:absinthe_plug, "~> 1.4"},
      {:dataloader, "~> 1.0.4"},
      {:mix_test_watch, "~> 0.9", only: :dev, runtime: false},
      {:apollo_tracing, "~> 0.4"},
      {:ex_machina, "~> 2.3"},
      {:argon2_elixir, "~> 2.0"},
      {:faker, "~> 0.11.2"},
      {:excoveralls, "~> 0.10", only: :test},
      {:bodyguard, "~> 2.2.3"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
