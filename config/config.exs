# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :opsmaru,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :opsmaru, OpsmaruWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: OpsmaruWeb.ErrorHTML, json: OpsmaruWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Opsmaru.PubSub,
  live_view: [signing_salt: "+XDN9vu0"]

config :opsmaru, Opsmaru.Cache,
  primary: [
    gc_interval: 3_600_000,
    backend: :shards
  ]

config :opsmaru, Opsmaru.Guardian,
  issuer: "instellar",
  secret_key: "XsaA1vyT1Z9bnBh5e0J/G9/lhQRpbypHKCgF0ZoAJTbj3ActaAMjt0Y7GuB+IkL2"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :opsmaru, Opsmaru.Mailer, adapter: Swoosh.Adapters.Local

config :stripity_stripe,
  api_version: "2022-11-15",
  api_key: System.get_env("STRIPE_SECRET")

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  opsmaru: [
    args:
      ~w(js/app.jsx --loader:.js=jsx --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.7",
  opsmaru: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
