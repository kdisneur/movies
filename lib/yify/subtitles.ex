defmodule YIFY.Subtitles do
  def find_by_imdb_id(imdb_id, languages), do: find_by_imdb_id(imdb_id) |> Map.take(languages)
  def find_by_imdb_id(imdb_id), do: YIFY.Subtitles.Request.get(YIFY.Subtitles.URL.build("/subs/" <> imdb_id))
end
