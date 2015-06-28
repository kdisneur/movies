defmodule Trakt do
  def authorize_url do
    Trakt.URL.oauth_authorize_url
  end

  def login(code) do
    result = Trakt.Request.post(Trakt.URL.exchange_code_url, %{
      client_id:     Trakt.Config.client_id,
      client_secret: Trakt.Config.client_secret,
      code:          code,
      grant_type:    :authorization_code,
      redirect_uri:  Trakt.Config.redirect_uri,
    })

    case result do
      %{ "access_token" => trakt_token }      -> find_and_update_user(trakt_token)
      %{ "error_description" => description } -> {:error, description}
    end
  end

  def own(user=%User{}, imdb_ids) when is_list(imdb_ids) do
    formatted_ids = imdb_ids |> Enum.map(fn(id) -> %{"ids" => %{"imdb" => id}} end)

    for url <- [Trakt.URL.add_owned_items_url, Trakt.URL.remove_whished_items_url(user.username)] do
      Trakt.Request.authenticated_post(user.profile.trakt_token, url, %{ "movies": formatted_ids })
    end |> hd
  end
  def own(user=%User{}, imdb_id), do: own(user, [imdb_id])

  def owned_movies(user=%User{}) do
    Trakt.Request.authenticated_get(user.profile.trakt_token, Trakt.URL.list_owned_items_url(user.username))
    |> Trakt.Movie.build
  end

  def rate(user=%User{}, imdb_id, rating) when rating >= 0 and rating <= 10 do
    Trakt.Request.authenticated_post(user.profile.trakt_token, Trakt.URL.add_ratings_url, %{
      "movies": [%{
        "rating" => rating,
        "ids" => %{
          "imdb" => imdb_id
        }
      }]
    })
  end

  def rating(user=%User{}, imdb_id) do
    ratings(user) |> Enum.find(%Trakt.Rating{imdb_id: imdb_id}, &(&1.imdb_id == imdb_id))
  end

  def ratings(user=%User{}) do
    Trakt.Request.authenticated_get(user.profile.trakt_token, Trakt.URL.list_ratings_url) |> Trakt.Rating.build
  end

  def search(user=%User{}, query) do
    Trakt.Request.authenticated_get(user.profile.trakt_token, Trakt.URL.search_movies_url(query)) |> Trakt.Movie.build
  end

  def wish(user=%User{}, imdb_id) do
    Trakt.Request.authenticated_post(
      user.profile.trakt_token,
      Trakt.URL.add_wished_items_url(user.username),
      %{
        "movies": [%{
          "ids": %{
            "imdb" => imdb_id
          }
        }]
      }
    )
  end

  def wished_movies(user=%User{}) do
    Trakt.Request.authenticated_get(user.profile.trakt_token, Trakt.URL.list_wished_items_url(user.username))
    |> Trakt.Movie.build
  end

  defp find_and_update_user(trakt_token) do
    %{ "user" => trakt_settings } = Trakt.Request.authenticated_get(trakt_token, Trakt.URL.settings_url)

    case User.find_by_username(trakt_settings["username"]) do
      {:error}    -> {:error, "Not authorized user"}
      {:ok, user} -> User.save(%User{user | profile: %Profile{user.profile | name: trakt_settings["name"], trakt_token: trakt_token}})
    end
  end
end
