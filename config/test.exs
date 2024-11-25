import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :opsmaru, OpsmaruWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "h1eZS8E0xl1sGAWsE3SttLut6NcDPpDIJ10ryiKcv4CKzJZwE1lnn/SUwSRGwrZ7",
  server: false

# In test we don't send emails
config :opsmaru, Opsmaru.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :opsmaru, :test_finch, OpsmaruTestFinch

config :sanity, Opsmaru.Sanity, http_options: [finch: OpsmaruTestFinch]

config :exvcr, [
  vcr_cassette_library_dir: "test/fixture/vcr_cassettes",
  custom_cassette_library_dir: "test/fixture/custom_cassettes",
  filter_sensitive_data: [],
  filter_url_params: false,
  filter_request_headers: [
    "authorization"
  ],
  response_headers_blacklist: []
]
