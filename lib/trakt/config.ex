defmodule Trakt.Config do
  def api_version, do: 2
  def client_id, do: get_env_variable("TRAKT_CLIENT_ID")
  def client_secret, do: get_env_variable("TRAKT_CLIENT_SECRET")
  def redirect_uri, do: get_env_variable("TRAKT_REDIRECT_URI")
  def root_url, do: get_env_variable("TRAKT_API_URL")

  defp get_env_variable(name), do: System.get_env("#{to_string(Mix.env) |> String.upcase}_#{name}") || System.get_env(name)
end
