defmodule Trakt.Config do
  def api_version, do: 2
  def client_id, do: System.get_env("TRAKT_CLIENT_ID")
  def client_secret, do: System.get_env("TRAKT_CLIENT_SECRET")
  def redirect_uri, do: System.get_env("TRAKT_REDIRECT_URI")
  def root_url, do: System.get_env("TRAKT_API_URL")
end
