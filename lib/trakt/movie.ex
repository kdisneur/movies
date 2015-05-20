defmodule Trakt.Movie do
  defstruct title: nil, year: nil, collected_at: nil, genres: [], poster: %Trakt.Poster{}, overview: nil, trailer: nil, runtime: 0, trakt_id: nil, imdb_id: nil

  def build(%{"collected_at" => collected_at, "movie" => movie}) do
    %Trakt.Movie{
      title:        movie["title"],
      year:         movie["year"],
      collected_at: collected_at,
      genres:       movie["genres"],
      overview:     movie["overview"],
      trailer:      movie["trailer"],
      runtime:      movie["runtime"],
      poster:       Trakt.Poster.build(movie["images"]),
      imdb_id:      movie["ids"]["imdb"],
      trakt_id:     movie["ids"]["trakt"]
    }
  end
  def build(list), do: build(list, [])
  def build([], result), do: result
  def build([raw_movie|tail], result), do: build(tail, result ++ [build(raw_movie)])
end
