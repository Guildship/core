# Since configuration is shared in umbrella projects, this file
# should only configure the :guildship application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :guildship, GuildshipWeb.Endpoint,
  http: [port: System.get_env("PORT", "8080")],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: true

config :guildship, Guildship.Repo,
  username: System.get_env("DB_USERNAME", "postgres"),
  password: System.get_env("DB_PASSWORD", "postgres"),
  database: System.get_env("DB_DATABASE", "guildship"),
  hostname: System.get_env("DB_HOSTNAME", "localhost"),
  pool_size: 10

config :logger, level: :info

config :libcluster,
  topologies: [
    k8s: [
      strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "gs-core-service-headless",
        application_name: "gs-core",
        polling_interval: 3_000
      ]
    ]
  ]
