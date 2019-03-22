# Since configuration is shared in umbrella projects, this file
# should only configure the :guildship application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :guildship, Guildship.Repo,
  username: "postgres",
  password: "postgres",
  database: "guildship_test",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :guildship, GuildshipWeb.Endpoint,
  http: [port: 4002],
  server: false

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
