defmodule YIFY.Subtitles.Request do
  def get(url) do
    case do_get(url) do
      %{ "success" => true, "subs" => results } ->
        [{ _, subtitles }] = results |> Map.to_list
        subtitles
      %{ "success" => true } -> %{}
    end
  end

  defp do_get(url), do: HTTPoison.get!(url) |> Poison.Parser.parse!
end
