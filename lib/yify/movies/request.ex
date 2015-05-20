defmodule YIFY.Movies.Request do
  def get(url) do
    case do_get(url) do
      %{ "status" => "ok", "data" => %{ "movies" => movies }} -> movies
    end
  end

  defp do_get(url) do
    case HTTPoison.get!(url) do
      %HTTPoison.Response{status_code: 200, body: body} -> body |> Poison.Parser.parse!
    end
  end
end
