defmodule Trakt do
  def wish(user=%User{}, imdb_id) do
    Trakt.Request.post(Trakt.URL.build("/users/#{user.username}/lists/wish-list/items"), %{
      "Authorization"     => "Bearer #{user.profile.trakt_token}",
      "trakt-api-version" => Trakt.Config.api_version,
      "trakt-api-key"     => Trakt.Config.client_id
    }, %{
      "movies": [%{
        "ids": %{
          "imdb" => imdb_id
        }
      }]
    })
  end

  def authorize_url do
    Trakt.URL.build("/oauth/authorize", %{
      response_type: :code,
      client_id:     Trakt.Config.client_id,
      redirect_uri:  Trakt.Config.redirect_uri
    })
  end

  def login(code) do
    result = Trakt.Request.post(Trakt.URL.build("/oauth/token"), %{
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

  def owned_movies(user=%User{}) do
    Trakt.Movie.build(Trakt.Request.get(Trakt.URL.build("/users/#{user.username}/collection/movies?extended=full,images"), %{
      "Authorization"     => "Bearer #{user.profile.trakt_token}",
      "trakt-api-version" => Trakt.Config.api_version,
      "trakt-api-key"     => Trakt.Config.client_id
    }))
  end

  def rate(user=%User{}, imdb_id, rating) when rating >= 0 and rating <= 10 do
    Trakt.Request.post(Trakt.URL.build("/sync/ratings"), %{
      "Authorization"     => "Bearer #{user.profile.trakt_token}",
      "trakt-api-version" => Trakt.Config.api_version,
      "trakt-api-key"     => Trakt.Config.client_id
    }, %{
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
    Trakt.Rating.build(Trakt.Request.get(Trakt.URL.build("/sync/ratings/movies"), %{
      "Authorization"     => "Bearer #{user.profile.trakt_token}",
      "trakt-api-version" => Trakt.Config.api_version,
      "trakt-api-key"     => Trakt.Config.client_id
    }))
  end

  def search(user=%User{}, query) do
    Trakt.Movie.build(Trakt.Request.get(Trakt.URL.build("/search?type=movie&query=#{query |> String.replace(" ", "+")}"), %{
      "Authorization"     => "Bearer #{user.profile.trakt_token}",
      "trakt-api-version" => Trakt.Config.api_version,
      "trakt-api-key"     => Trakt.Config.client_id
    }))
  end

  def wished_movies(user=%User{}) do
    Trakt.Movie.build(Trakt.Request.get(Trakt.URL.build("/users/#{user.username}/lists/wish-list/items?extended=full,images"), %{
      "Authorization"     => "Bearer #{user.profile.trakt_token}",
      "trakt-api-version" => Trakt.Config.api_version,
      "trakt-api-key"     => Trakt.Config.client_id
    }))
  end

  defp find_and_update_user(trakt_token) do
    %{ "user" => trakt_settings } = Trakt.Request.get(Trakt.URL.build("/users/settings"), %{
      "Authorization"     => "Bearer #{trakt_token}",
      "trakt-api-version" => Trakt.Config.api_version,
      "trakt-api-key"     => Trakt.Config.client_id
    })

    case User.find_by_username(trakt_settings["username"]) do
      {:error}    -> {:error, "Not authorized user"}
      {:ok, user} -> User.save(%User{user | profile: %Profile{user.profile | name: trakt_settings["name"], trakt_token: trakt_token}})
    end
  end
end
