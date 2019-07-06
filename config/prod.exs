# Since configuration is shared in umbrella projects, this file
# should only configure the :guildship application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :guildship, Guildship.Repo,
  url:
    System.get_env("DB_URL") || "ecto://postgres:postgres@localhost/guildship",
  pool_size: 10

config :logger, level: :info
