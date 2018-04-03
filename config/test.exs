use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bijakhq, BijakhqWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :bijakhq, Bijakhq.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATA_DB_USER") || "postgres",
  password: System.get_env("DATA_DB_PASS") || "postgres",
  hostname: System.get_env("DATA_DB_HOST") || "localhost",
  database: "bijakhq_test",
  pool: Ecto.Adapters.SQL.Sandbox
