defmodule Plug.FetchUser do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _config) do
    conn = conn |> fetch_by_username
    case conn.assigns[:user] do
      %User{} -> conn
      _       -> conn |> fetch_by_api_key
    end
  end

  defp fetch_by_username(conn) do
    username = conn |> fetch_session |> get_session("username")
    user = case User.find_by_username(username) do
      {:ok, user} -> user
      {:error}    -> nil
    end

    %{ conn | assigns: Map.put(conn.assigns, :user, user) }
  end

  defp fetch_by_api_key(conn) do
    user = case conn.req_headers |> Enum.find(&match_api_key/1) do
      nil     -> nil
      api_key -> case User.find_by_trakt_token(api_key) do
        user = %User{} -> user
        _       -> nil
      end
    end

    %{ conn | assigns: Map.put(conn.assigns, :user, user) }
  end

  defp match_api_key({"api-key", api_key}), do: api_key
  defp match_api_key(_), do: nil
end
