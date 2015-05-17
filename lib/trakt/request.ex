defmodule Trakt.Request do
  def get(url, headers) do
    case HTTPoison.get(url, merge_headers(headers)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body |> Poison.Parser.parse!
    end
  end

  def post(url, body) do
    case HTTPoison.post(url, body_to_json(body), default_headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body |> Poison.Parser.parse!
      {:ok, %HTTPoison.Response{status_code: 401, body: body}} -> body |> Poison.Parser.parse!
    end
  end

  defp body_to_json(body), do: Poison.Encoder.encode(body, %{})
  defp merge_headers(headers), do: Map.merge(headers, default_headers)
  defp default_headers, do: %{ "Content-Type" => "application/json" }
end
