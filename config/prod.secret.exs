use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :movies, Movies.Endpoint,
  secret_key_base: "hSIeIfRmtm7BmoVsL4bw0HRE4rvBYn4v1NQ/XcRNilAIFATP8VqKQPu1qK6++iJq"

# Configure your database
config :movies, Movies.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "movies_prod"
