# Since configuration is shared in umbrella projects, this file
# should only configure the :guildship application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :guildship, GuildshipWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT", "8000")],
  url: [host: "guildship.co", port: 80]

config :logger, level: :info
