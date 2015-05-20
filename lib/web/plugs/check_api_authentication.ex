defmodule Plug.CheckAPIAuthentication do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _config) do
    case conn.req_headers |> Enum.find_value(&match_api_key/1) do
      nil     -> conn |> not_authorized
      api_key -> case User.find_by_trakt_token(api_key) do
        %User{} -> conn
        _       -> conn |> not_authorized
      end
    end
  end

  defp not_authorized(conn), do: conn |> resp(401, "Unauthorized") |> halt
  defp match_api_key({"api-key", api_key}), do: api_key
  defp match_api_key(_), do: nil
end
