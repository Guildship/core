defmodule Guildship.Repo do
  use Ecto.Repo,
    otp_app: :guildship,
    adapter: Ecto.Adapters.Postgres,
    pool_size: 10

  def init(_type, config) do
    keywords =
      config
      |> Keyword.put(:url, System.get_env("DB_URL"))

    {:ok, keywords}
    |> IO.inspect()
  end
end
