use Mix.Config

port = String.to_integer(System.get_env("PORT") || "4000")
default_secret_key_base = :crypto.strong_rand_bytes(43) |> Base.encode64()

config :guildship, GuildshipWeb.Endpoint,
  http: [port: port],
  url: [host: "localhost", port: port],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || default_secret_key_base

config :guildship, Guildship.Repo,
  url:
    System.get_env("DB_URL") || "ecto://postgres:postgres@localhost/guildship",
  pool_size: 10
