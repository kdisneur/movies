defmodule Trakt.Movie do

  defmacro has_poster?(movie) do
    quote do
      movie["images"]["poster"]["full"] != null
    end
  end

  defstruct title: nil, year: nil, genres: [], poster: %Trakt.Poster{}, overview: nil, trailer: nil, runtime: 0, trakt_id: nil, imdb_id: nil

  def build(%{"movie" => movie}) do
    %Trakt.Movie{
      title:        movie["title"],
      year:         movie["year"],
      genres:       movie["genres"] || [],
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
  def build([raw_movie=%{"movie" => %{"images" => %{"poster" => %{"full" => full_poster}}}}|tail], result) when is_binary(full_poster) do
    build(tail, result ++ [build(raw_movie)])
  end
  def build([_|tail], result), do: build(tail, result)
end
