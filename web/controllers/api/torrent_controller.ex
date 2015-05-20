defmodule Movies.API.TorrentController do
  use Movies.Web, :controller

  plug :action

  def show(conn, %{"imdb_id" => imdb_id}) do
    render(conn, "show.json", movie: YIFY.Movies.find_by_imdb_id(imdb_id))
  end
end
