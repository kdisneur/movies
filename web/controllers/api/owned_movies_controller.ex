defmodule Movies.API.OwnedMoviesController do
  use Movies.Web, :controller

  plug :action

  def index(conn, _params) do
    render(conn, "index.json", movies: Trakt.owned_movies(conn.assigns[:user]))
  end

  def create(conn, %{"imdb_id" => imdb_id}) do
    Trakt.own(conn.assigns[:user], imdb_id)

    conn |> put_resp_content_type("text/plain")
         |> send_resp(201, ~s({ "success": true }))
  end
end
