defmodule Movies.API.SubtitleView do
  use Movies.Web, :view

  def render("show.json", %{subtitles: subtitles}), do: subtitles |> Map.to_list |> Enum.map(&reformat_subtitles/1) |> List.flatten

  defp reformat_subtitles({lang, list}), do: reformat_subtitles({lang, list}, [])
  defp reformat_subtitles({lang, []}, result), do: result
  defp reformat_subtitles({lang, [subtitle|tail]}, result), do: reformat_subtitles({lang, tail}, result ++ [reformat_subtitle(lang, subtitle)])

  defp reformat_subtitle(lang, subtitle), do: Map.merge(subtitle, %{"name" => lang, "url" => "http://wwww.yifysubtitles.com" <> subtitle["url"]})
end
