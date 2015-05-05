defmodule YIFY.Movies.URL do
  @url     "https://yts.to/api"
  @version 2

  def build(path), do: root_url <> path
  def build(path, terms), do: build(path) <> "?" <> terms_to_query_string(terms)

  defp root_url, do: @url <> "/v" <> Integer.to_string(@version)
  defp terms_to_query_string({ key, value}), do: "#{key}=#{value}"
  defp terms_to_query_string(terms), do: terms |> Map.to_list |> Enum.map(&terms_to_query_string/1) |> Enum.join("&")
end
