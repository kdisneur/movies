defmodule Movies.API.TorrentView do
  use Movies.Web, :view

  def render("show.json", %{movie: movies}), do: movies
end
