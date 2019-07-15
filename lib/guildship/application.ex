defmodule Guildship.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias GuildshipWeb.Endpoint

  def start(_type, _args) do
    :ok = Logger.add_translator({Timber.Exceptions.Translator, :translate})

    children = [
      Guildship.Repo,
      Endpoint
    ]

    opts = [strategy: :one_for_one, name: Guildship.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
