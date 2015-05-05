defmodule YIFY.Subtitles.URL do
  @url "http://api.yifysubtitles.com"

  def build(path), do: root_url <> path

  defp root_url, do: @url
end
