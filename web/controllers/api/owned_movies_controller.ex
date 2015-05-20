defmodule Movies.API.OwnedMoviesController do
  use Movies.Web, :controller

  plug :action

  def index(conn, _params) do
    render(conn, "index.json", movies: Trakt.owned_movies(conn.assigns[:user]))
  end
end
