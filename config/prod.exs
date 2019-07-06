# Since configuration is shared in umbrella projects, this file
# should only configure the :guildship application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :guildship, GuildshipWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  # This is critical for ensuring web-sockets properly authorize.
  url: [host: "localhost", port: System.get_env("PORT")],
  server: true,
  root: ".",
  version: Application.spec(:guildship, :vsn)

config :guildship, Guildship.Repo,
  url:
    System.get_env("DB_URL") || "ecto://postgres:postgres@localhost/guildship",
  pool_size: 10

config :logger, level: :info
