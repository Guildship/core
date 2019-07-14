defmodule Guildship.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias GuildshipWeb.Endpoint

  def start(_type, _args) do
    children = [
      Guildship.Repo,
      Endpoint
    ]

    :ok = Logger.add_translator({Timber.Exceptions.Translator, :translate})

    :ok =
      :telemetry.attach(
        "timber-ecto-query-handler",
        [:guildship, :repo, :query],
        &Timber.Ecto.handle_event/4,
        # Only care about queries that exceed 1s
        query_time_ms_threshold: 1_000
      )

    opts = [strategy: :one_for_one, name: Guildship.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
