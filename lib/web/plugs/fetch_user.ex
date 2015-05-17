defmodule Plug.FetchUser do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _config) do
    username = conn |> fetch_session |> get_session("username")
    user = case User.find_by_username(username) do
      {:ok, user} -> user
      {:error}    -> nil
    end

    %{ conn | assigns: Map.put(conn.assigns, :user, user) }
  end
end
