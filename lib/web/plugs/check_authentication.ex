defmodule Plug.CheckAuthentication do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _config) do
    username = conn |> fetch_session |> get_session("username")
    case User.find_by_username(username) do
      {:ok, _} -> conn
      {:error} -> conn |> put_resp_header("Location", "/") |> resp(302, "") |> halt
    end
  end
end
