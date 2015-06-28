defmodule Trakt.Request do
  def authenticated_get(token, url), do: get(url, merge_authenticated_headers(token, %{}))
  def authenticated_get(token, url, headers), do: get(url, merge_authenticated_headers(token, headers))
  def authenticated_post(token, url, body), do: post(url, merge_authenticated_headers(token, %{}), body)
  def authenticated_post(token, url, headers, body), do: post(url, merge_authenticated_headers(token, headers), body)

  def get(url, headers) do
    case HTTPoison.get(url, merge_headers(headers)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body |> Poison.Parser.parse!
    end
  end

  def post(url, body), do: post(url, %{}, body)
  def post(url, headers, body) do
    case HTTPoison.post(url, body_to_json(body), Map.merge(default_headers, headers)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body |> Poison.Parser.parse!
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} -> body |> Poison.Parser.parse!
      {:ok, %HTTPoison.Response{status_code: 401, body: body}} -> body |> Poison.Parser.parse!
    end
  end

  defp body_to_json(body), do: Poison.Encoder.encode(body, %{})
  defp merge_authenticated_headers(token, headers) do
    Map.merge(%{
     "Authorization"     => "Bearer #{token}",
     "trakt-api-version" => Trakt.Config.api_version,
     "trakt-api-key"     => Trakt.Config.client_id
    }, headers)
  end
  defp merge_headers(headers), do: Map.merge(headers, default_headers)
  defp default_headers, do: %{ "Content-Type" => "application/json" }
end
