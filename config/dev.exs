# Since configuration is shared in umbrella projects, this file
# should only configure the :guildship application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :guildship, Guildship.Repo,
  username: "postgres",
  password: "postgres",
  database: "guildship_dev",
  hostname: "localhost",
  pool_size: 10

config :guildship, GuildshipWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :argon2_elixir,
  t_cost: 1,
  m_cost: 4
