defmodule Movies.OwnedMoviesController do
  use Movies.Web, :controller

  plug :action

  def index(conn, _params), do: render(conn, "index.html")
end
