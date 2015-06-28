defmodule Trakt.URL do
  def build(path), do: build(path, %{})
  def build(path, params), do: [Trakt.Config.root_url <> path, build_params(params)] |> Enum.filter(fn e -> String.length(e) > 0 end) |> Enum.join("?")

  def exchange_code_url, do: build("/oauth/token")

  def oauth_authorize_url do
    build("/oauth/authorize", %{
      response_type: :code,
      client_id:     Trakt.Config.client_id,
      redirect_uri:  Trakt.Config.redirect_uri
    })
  end

  def add_owned_items_url, do: build("/sync/collection")
  def add_ratings_url, do: build("/sync/ratings")
  def add_wished_items_url(username), do: build("/users/#{username}/lists/wish-list/items")

  def list_owned_items_url(username), do: build("/users/#{username}/collection/movies?extended=full,images")
  def list_ratings_url, do: build("/sync/ratings/movies")
  def list_wished_items_url(username), do: build("/users/#{username}/lists/wish-list/items?extended=full,images")

  def remove_whished_items_url(username), do: build("/users/#{username}/lists/wish-list/items/remove")

  def search_movies_url(query_string) do
    build("/search", %{
      query: query_string |> String.replace(" ", "+"),
      type:  :movie
    })
  end

  def settings_url, do: build("/users/settings")

  defp build_param({key, value}), do: "#{key}=#{value}"
  defp build_params(params=%{}), do: params |> Map.to_list |> Enum.map(&build_param/1) |> Enum.join("&")
end
