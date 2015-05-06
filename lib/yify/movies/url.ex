defmodule YIFY.Movies.URL do
  @url     "https://yts.to/api"
  @version 2

  @doc ~S"""
  Build an URL to Yify based onf the given `path`

  ## Examples
    iex> YIFY.Movies.URL.build("/my-path")
    "https://yts.to/api/v2/my-path"

  """
  def build(path), do: root_url <> path

  @doc ~S"""
  Build an URL to Yify based onf the given `path` and a hash of `terms`

  ## Examples
    iex> YIFY.Movies.URL.build("/my-path", %{ term1: "value1", term2: 1337 })
    "https://yts.to/api/v2/my-path?term1=value1&term2=1337"

    iex> YIFY.Movies.URL.build("/my-path", %{ })
    "https://yts.to/api/v2/my-path"

  """
  def build(path, terms), do: [build(path), terms_to_query_string(terms)] |> Enum.filter(fn s -> String.length(s) > 0 end) |> Enum.join("?")

  defp root_url, do: @url <> "/v" <> Integer.to_string(@version)
  defp terms_to_query_string({ key, value }), do: "#{key}=#{value}"
  defp terms_to_query_string(terms), do: terms |> Map.to_list |> Enum.map(&terms_to_query_string/1) |> Enum.join("&")
end
