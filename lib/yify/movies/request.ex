defmodule YIFY.Movies.Request do
  def get(url) do
    case do_get(url) do
      %{ "status" => "ok", "data" => %{ "movies" => movies }} -> movies
    end
  end

  defp do_get(url), do: HTTPoison.get!(url) |> Poison.Parser.parse!
end
