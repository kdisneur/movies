defmodule Movies.API.SubtitleController do
  use Movies.Web, :controller

  plug :action

  def show(conn, %{"imdb_id" => imdb_id}) do
    render(conn, "show.json", subtitles: YIFY.Subtitles.find_by_imdb_id(imdb_id, ["english", "french"]))
  end
end
