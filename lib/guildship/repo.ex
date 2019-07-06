defmodule Guildship.Repo do
  use Ecto.Repo,
    otp_app: :guildship,
    adapter: Ecto.Adapters.Postgres,
    pool_size: 10

  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DB_URL"))}
  end
end
