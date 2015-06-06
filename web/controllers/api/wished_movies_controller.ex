defmodule Movies.API.WishedMoviesController do
  use Movies.Web, :controller

  plug :action

  def index(conn, _params), do: render(conn, "index.json", movies: Trakt.wished_movies(conn.assigns[:user]))
end
