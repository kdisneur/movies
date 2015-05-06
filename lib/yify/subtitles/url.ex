defmodule YIFY.Subtitles.URL do
  @url "http://api.yifysubtitles.com"

  @doc ~S"""
  Build an URL to Yify subtitles based onf the given `path`

  ## Examples
    iex> YIFY.Subtitles.URL.build("/my-path")
    "http://api.yifysubtitles.com/my-path"

  """
  def build(path), do: root_url <> path

  defp root_url, do: @url
end
