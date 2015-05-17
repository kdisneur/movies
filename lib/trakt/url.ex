defmodule Trakt.URL do
  def build(path), do: build(path, %{})
  def build(path, params), do: [Trakt.Config.root_url <> path, build_params(params)] |> Enum.filter(fn e -> String.length(e) > 0 end) |> Enum.join("?")

  defp build_param({key, value}), do: "#{key}=#{value}"
  defp build_params(params=%{}), do: params |> Map.to_list |> Enum.map(&build_param/1) |> Enum.join("&")
end
