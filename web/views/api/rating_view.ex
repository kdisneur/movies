defmodule Movies.API.RatingView do
  use Movies.Web, :view

  def render("index.json", %{ratings: ratings}), do: ratings
end
