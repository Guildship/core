# Since configuration is shared in umbrella projects, this file
# should only configure the :guildship application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :guildship,
  ecto_repos: [Guildship.Repo]

# Configures the endpoint
config :guildship, GuildshipWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "lTNegs78/QN3mC32AjFrdHt6FjRSyqbQb7bik0z9+ybDBoaiLW8wEcl5W4X63zNt",
  render_errors: [view: GuildshipWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: GuildshipWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :guildship, Guildship.Guardian,
  issuer: "guildship",
  secret_key: "lTNegs78/QN3mC32AjFrdHt6FjRSyqbQb7bik0z9+ybDBoaiLW8wEcl5W4X63zNt"

config :guildship, Guildship.Repo, migration_timestamps: [type: :utc_datetime]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :argon2_elixir,
  parallelism: :erlang.system_info(:logical_processors)

import_config "#{Mix.env()}.exs"
