defmodule Movies.PageController do
  use Movies.Web, :controller

  plug :redirect_when_authenticated
  plug :action

  def index(conn, _params), do: render(conn, "index.html")

  defp redirect_when_authenticated(conn, _params) do
    case conn.assigns[:user] do
      %User{} -> conn |> redirect(to: owned_movies_path(conn, :index)) |> halt
      _       -> conn
    end
  end
end
