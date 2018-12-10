# Since configuration is shared in umbrella projects, this file
# should only configure the :guildship application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

hashid_alphabet =
  [
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "abcdefghijklmnopqrstuvwxyz",
    "1234567890"
  ]
  |> Enum.join()

config :guildship,
  ecto_repos: [Guildship.Repo],
  hashid_alphabet: hashid_alphabet,
  hashid_min_length: 4,
  # NOTE: SALT CANNOT BE REALLY LONG
  # https://github.com/ivanakimov/hashids.js/issues/37
  #
  # With the alphabet we have (ALPHA / NUMERIC), it seems best to
  # make the length of the salt 21 characters
  hashid_salt: "7Ue9x18vLAOiN8PuWiYEJ"

# Configures the endpoint
config :guildship, GuildshipWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "lTNegs78/QN3mC32AjFrdHt6FjRSyqbQb7bik0z9+ybDBoaiLW8wEcl5W4X63zNt",
  render_errors: [view: GuildshipWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: GuildshipWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
