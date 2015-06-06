use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :movies, Movies.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
config :movies, redis_url: "redis://127.0.0.1:6379/1"
