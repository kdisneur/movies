defmodule YIFY.Subtitles.Request do
  def get(url) do
    case do_get(url) do
      %{ "success" => true, "subs" => results } ->
        [{ _, subtitles }] = results |> Map.to_list
        subtitles
      %{ "success" => true } -> %{}
    end
  end

  defp do_get(url) do
    case HTTPoison.get!(url) do
      %HTTPoison.Response{status_code: 200, body: body} -> body |> Poison.Parser.parse!
    end
  end
end
