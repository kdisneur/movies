defmodule Movies.API.SearchMoviesView do
  use Movies.Web, :view

  def render("index.json", %{movies: movies}), do: movies
end
