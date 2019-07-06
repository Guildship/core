# Since configuration is shared in umbrella projects, this file
# should only configure the :guildship application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :guildship, GuildshipWeb.Endpoint,
  http: [port: System.get_env("PORT") || "8080"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: true

config :guildship, Guildship.Repo,
  url: System.get_env("DB_URL") || "ecto://postgres:postgres@localhost/guildship"
  pool_size: 10

config :logger, level: :info
