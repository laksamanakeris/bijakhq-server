# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bijakhq,
  ecto_repos: [Bijakhq.Repo]

# Configures the endpoint
config :bijakhq, BijakhqWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oAdfNSfyb1IA5os5QiWtlZ7npPCnuQZyk+nG8K2Xx3oDcjCW9eDrh3XGPANm77RS",
  render_errors: [view: BijakhqWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bijakhq.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Phauxth authentication configuration
config :phauxth,
  token_salt: "CPTV+oxZ",
  endpoint: BijakhqWeb.Endpoint

# Mailer configuration
config :bijakhq, Bijakhq.Mailer,
  adapter: Bamboo.LocalAdapter

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Storage
config :arc,
  storage: Arc.Storage.GCS,
  bucket: "bijakhq"

config :goth,
  json: "keys/bijakhq-dev-6a9c509c6c90.json" |> Path.expand |> File.read!

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
