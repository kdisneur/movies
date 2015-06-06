defmodule Trakt.Rating do
  defstruct imdb_id: nil, rating: 0

  def build(%{"rating" => rating, "movie" => movie}) do
    %Trakt.Rating{
      rating:  rating,
      imdb_id: movie["ids"]["imdb"],
    }
  end
  def build(list), do: build(list, [])
  def build([], result), do: result
  def build([raw_rating|tail], result), do: build(tail, result ++ [build(raw_rating)])
end
