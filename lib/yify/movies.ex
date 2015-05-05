defmodule YIFY.Movies do
  def find_by_imdb_id(imdb_id), do: where(%{ query_term: imdb_id })
  def where(terms), do: YIFY.Movies.Request.get(YIFY.Movies.URL.build("/list_movies.json", terms))
end
