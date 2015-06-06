defmodule Movies.API.SearchMoviesController do
  use Movies.Web, :controller

  plug :action

  def index(conn, %{"q" => query}), do: render(conn, "index.json", movies: Trakt.search(conn.assigns[:user], query))
end
