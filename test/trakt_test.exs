defmodule TraktTest do
  use ExUnit.Case, async: false

  import Mock

  setup do
    client = Exredis.start_using_connection_string(Application.get_env(:movies, :redis_url))
    client |> Exredis.query(["FLUSHDB"])

    :ok
  end

  def user, do: %User{username: "neo", profile: %Profile{trakt_token: "good-token"}}

  test "authorize_url" do
    assert Trakt.authorize_url == "https://api-v2launch.trakt.tv/oauth/authorize?client_id=xxxx-xxxx-xxxx-xxxx&redirect_uri=http://test.dev/auth/trakt&response_type=code"
  end

  test "login with correct code" do
    with_mock HTTPoison, [post: fn("https://api-v2launch.trakt.tv/oauth/token", body, %{"Content-Type" => "application/json"}) ->
                            expected_body = Poison.Encoder.encode(%{client_id: "xxxx-xxxx-xxxx-xxxx", client_secret: "yyyy-yyyy-yyyy-yyyy", code: "good_code", grant_type: :authorization_code, redirect_uri: "http://test.dev/auth/trakt"}, %{})
                            case body do
                              ^expected_body -> {:ok, %HTTPoison.Response{status_code: 200, body: ~s({ "access_token": "good-token", "token_type": "bearer", "expires_in": 7200, "refresh_token": "good-refresh-token", "scope": "public" })}}
                              _              -> {:error}
                            end
                          end,
                          get:  fn("https://api-v2launch.trakt.tv/users/settings", %{"Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx", "Content-Type" => "application/json"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: ~s({ "user": { "username": "neo", "private": false, "name": "Neo", "vip": true, "vip_ep": false, "joined_at": "2010-09-25T17:49:25.000Z", "location": "San Diego, CA", "about": "Co-founder of trakt.", "gender": "male", "age": 32, "images": { "avatar": { "full": "https://secure.gravatar.com/avatar/30c2f0dfbc39e48656f40498aa871e33?r=pg&s=256" } } }, "account": { "timezone": "America/Los_Angeles", "time_24hr": false, "cover_image": "https://walter.trakt.us/images/movies/000/001/545/fanarts/original/0abb604492.jpg?1406095042" }, "connections": { "facebook": true, "twitter": true, "google": true, "tumblr": false }, "sharing_text": { "watching": "I'm watching [item]", "watched": "I just watched [item]"}})}} end] do
      {:error, "Not authorized user"} = Trakt.login("good_code")
      User.save(%User{username: "neo"})
      {:ok, %User{profile: %Profile{name: "Neo", trakt_token: "good-token"}}} = Trakt.login("good_code")
    end
  end

  test "login with incorrect code" do
    with_mock HTTPoison, [post: fn("https://api-v2launch.trakt.tv/oauth/token", body, %{"Content-Type" => "application/json"}) ->
                                  expected_body = Poison.Encoder.encode(%{client_id: "xxxx-xxxx-xxxx-xxxx", client_secret: "yyyy-yyyy-yyyy-yyyy", code: "bad_code", grant_type: :authorization_code, redirect_uri: "http://test.dev/auth/trakt"}, %{})
                                  case body do
                                    ^expected_body -> {:ok, %HTTPoison.Response{status_code: 401, body: ~s({ "error": "invalid_grant", "error_description": "long explanation" })}}
                                    _              -> {:error}
                                  end
                                end] do
      {:error, "long explanation"} = Trakt.login("bad_code")
    end
  end

  test "fetch movies for user" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/users/neo/collection/movies?extended=full,images", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: ~s([ { "collected_at": "2014-09-01T09:10:11.000Z", "movie": { "title": "TRON: Legacy", "year": 2010, "genres": ["action"], "overview": "an overview", "trailer": "link-to-youtube", "runtime": 175, "images": { "poster": { "full": "https://walter.trakt.us/images/movies/000/000/001/posters/full/e0d9dd35c5.jpg?1400478209", "medium": "https://walter.trakt.us/images/movies/000/000/001/posters/medium/e0d9dd35c5.jpg?1400478209", "thumb": "https://walter.trakt.us/images/movies/000/000/001/posters/thumb/e0d9dd35c5.jpg?1400478209" }}, "ids": { "trakt": 1, "slug": "tron-legacy-2010", "imdb": "tt1104001", "tmdb": 20526 } } }, { "collected_at": "2014-09-01T09:10:11.000Z", "movie": { "title": "The Dark Knight", "year": 2008, "genres": ["science fiction"], "overview": "an overview", "trailer": "link-to-youtube", "runtime": 210, "images": { "poster": { "full": "https://walter.trakt.us/images/movies/000/000/001/posters/full/e0d9dd35c5.jpg?1400478209", "medium": "https://walter.trakt.us/images/movies/000/000/001/posters/medium/e0d9dd35c5.jpg?1400478209", "thumb": "https://walter.trakt.us/images/movies/000/000/001/posters/thumb/e0d9dd35c5.jpg?1400478209" }}, "ids": { "trakt": 6, "slug": "the-dark-knight-2008", "imdb": "tt0468569", "tmdb": 155 } } } ])}} end] do
      [
        %Trakt.Movie{
          title:        "TRON: Legacy",
          year:         2010,
          genres:       ["action"],
          overview:     "an overview",
          trailer:      "link-to-youtube",
          runtime:      175,
          poster:       %Trakt.Poster{
            full:   "https://walter.trakt.us/images/movies/000/000/001/posters/full/e0d9dd35c5.jpg?1400478209",
            medium: "https://walter.trakt.us/images/movies/000/000/001/posters/medium/e0d9dd35c5.jpg?1400478209",
            thumb:  "https://walter.trakt.us/images/movies/000/000/001/posters/thumb/e0d9dd35c5.jpg?1400478209"
          },
          imdb_id:      "tt1104001",
          trakt_id:     1
        },
        %Trakt.Movie{
          title:        "The Dark Knight",
          year:         2008,
          genres:       ["science fiction"],
          overview:     "an overview",
          trailer:      "link-to-youtube",
          runtime:      210,
          poster:       %Trakt.Poster{
            full:   "https://walter.trakt.us/images/movies/000/000/001/posters/full/e0d9dd35c5.jpg?1400478209",
            medium: "https://walter.trakt.us/images/movies/000/000/001/posters/medium/e0d9dd35c5.jpg?1400478209",
            thumb:  "https://walter.trakt.us/images/movies/000/000/001/posters/thumb/e0d9dd35c5.jpg?1400478209"
          },
          imdb_id:      "tt0468569",
          trakt_id:     6
        }
      ] = Trakt.owned_movies(user)
    end
  end

  test "rate a movie" do
    with_mock HTTPoison, [post: fn("https://api-v2launch.trakt.tv/sync/ratings", body, %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) ->
                                  expected_body = Poison.Encoder.encode(%{"movies" => [%{ "rating" => 8, "ids" => %{"imdb" => "tt1104001"}}]}, %{})
                                  case body do
                                    ^expected_body -> {:ok, %HTTPoison.Response{status_code: 201, body: ~s({ "added": { "movies": 1, "shows": 0, "seasons": 0, "episodes": 0 }, "not_found": { "movies": [], "shows": [], "seasons": [], "episodes": [] } })}}
                                    _              -> nil
                                  end
                                end] do
      %{"added" => %{"movies" => 1}} = Trakt.rate(user, "tt1104001", 8)
    end
  end

  test "find user rating for one movie" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/sync/ratings/movies", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: ~s([ { "rated_at": "2014-09-01T09:10:11.000Z", "rating": 10, "movie": { "title": "TRON: Legacy", "year": 2010, "ids": { "trakt": 1, "slug": "tron-legacy-2010", "imdb": "tt1104001", "tmdb": 20526 } } }, { "rated_at": "2014-09-01T09:10:11.000Z", "rating": 8, "movie": { "title": "The Dark Knight", "year": 2008, "ids": { "trakt": 6, "slug": "the-dark-knight-2008", "imdb": "tt0468569", "tmdb": 155 } } } ])}} end] do
      %Trakt.Rating{rating: 10, imdb_id: "tt1104001"} = Trakt.rating(user, "tt1104001")
    end
  end

  test "find all user ratings" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/sync/ratings/movies", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: ~s([ { "rated_at": "2014-09-01T09:10:11.000Z", "rating": 10, "movie": { "title": "TRON: Legacy", "year": 2010, "ids": { "trakt": 1, "slug": "tron-legacy-2010", "imdb": "tt1104001", "tmdb": 20526 } } }, { "rated_at": "2014-09-01T09:10:11.000Z", "rating": 8, "movie": { "title": "The Dark Knight", "year": 2008, "ids": { "trakt": 6, "slug": "the-dark-knight-2008", "imdb": "tt0468569", "tmdb": 155 } } } ])}} end] do
      [
        %Trakt.Rating{rating: 10, imdb_id: "tt1104001"},
        %Trakt.Rating{rating:  8, imdb_id: "tt0468569"}
      ] = Trakt.ratings(user)
    end
  end

  test "search a films" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/search?type=movie&query=film+with+spaces", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: ~s([{ "type": "movie", "score": 106.818695, "movie": { "title": "Dark Places", "overview": "A woman who survived the brutal killing of her family as a child is forced to confront the events of that day.", "year": 2015, "images": { "poster": { "full": "https://walter.trakt.us/images/movies/000/114/696/posters/original/fa9e297dd1.jpg", "medium": "https://walter.trakt.us/images/movies/000/114/696/posters/medium/fa9e297dd1.jpg", "thumb": "https://walter.trakt.us/images/movies/000/114/696/posters/thumb/fa9e297dd1.jpg" }, "fanart": { "full": null, "medium": null, "thumb": null } }, "ids": { "trakt": 114696, "slug": "dark-places-2014", "imdb": "tt2402101", "tmdb": 182560 } } }, { "type": "movie", "score": 0.7720646, "movie": { "title": "Scouts vs. Zombies", "overview": "Tye Sheridan (\\"Mud,\\" \\"Dark Places\\"\), Logan Miller (\\"I'm in the Band,\\" \\"Night Moves\\"\), and newcomer Joey Morgan are three scouts who, on the eve of their last camp out, discover the true meaning of friendship when they attempt to save their town from a zombie outbreak.", "year": 2015, "images": { "poster": { "full": null, "medium": null, "thumb": null }, "fanart": { "full": null, "medium": null, "thumb": null } }, "ids": { "trakt": 171365, "slug": "scouts-vs-zombies-2015", "imdb": "tt1727776", "tmdb": 273477 } } } ])}} end] do
      [
        %Trakt.Movie{
          title: "Dark Places",
          year:  2015,
          poster: %Trakt.Poster{
            full:   "https://walter.trakt.us/images/movies/000/114/696/posters/original/fa9e297dd1.jpg",
            medium: "https://walter.trakt.us/images/movies/000/114/696/posters/medium/fa9e297dd1.jpg",
            thumb:  "https://walter.trakt.us/images/movies/000/114/696/posters/thumb/fa9e297dd1.jpg"
          },
          imdb_id:  "tt2402101",
          trakt_id: 114696
        },
      ] = Trakt.search(user, "film with spaces")
    end
  end

  test "wish a movie" do
    with_mock HTTPoison, [post: fn("https://api-v2launch.trakt.tv/users/neo/lists/wish-list/items", body, %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) ->
                                 expected_body = Poison.Encoder.encode(%{"movies" => [%{ "ids" => %{"imdb" => "tt1104001"}}]}, %{})
                                 case body do
                                   ^expected_body -> {:ok, %HTTPoison.Response{status_code: 201, body: ~s({ "added": { "movies": 1, "shows": 0, "seasons": 0, "episodes": 0, "people": 0 }, "existing": { "movies": 0, "shows": 0, "seasons": 0, "episodes": 0, "people": 0 }, "not_found": { "movies": [], "shows": [], "seasons": [], "episodes": [] } })}}
                                   _ -> nil
                                 end
                               end] do
       %{"added" => %{"movies" => 1}} = Trakt.wish(user, "tt1104001")
    end
  end

  test "wish list" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/users/neo/lists/wish-list/items?extended=full,images", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: ~s([ { "listed_at": "2014-09-01T09:10:11.000Z", "type": "movie", "movie": { "title": "TRON: Legacy", "year": 2010, "genres": ["action"], "overview": "an overview", "trailer": "link-to-youtube", "runtime": 175, "images": { "poster": { "full": "https://walter.trakt.us/images/movies/000/000/001/posters/full/e0d9dd35c5.jpg?1400478209", "medium": "https://walter.trakt.us/images/movies/000/000/001/posters/medium/e0d9dd35c5.jpg?1400478209", "thumb": "https://walter.trakt.us/images/movies/000/000/001/posters/thumb/e0d9dd35c5.jpg?1400478209" }}, "ids": { "trakt": 1, "slug": "tron-legacy-2010", "imdb": "tt1104001", "tmdb": 20526 } } }, { "listed_at": "2014-09-01T09:10:11.000Z", "type": "movie", "movie": { "title": "The Dark Knight", "year": 2008, "genres": ["science fiction"], "overview": "an overview", "trailer": "link-to-youtube", "runtime": 210, "images": { "poster": { "full": "https://walter.trakt.us/images/movies/000/000/001/posters/full/e0d9dd35c5.jpg?1400478209", "medium": "https://walter.trakt.us/images/movies/000/000/001/posters/medium/e0d9dd35c5.jpg?1400478209", "thumb": "https://walter.trakt.us/images/movies/000/000/001/posters/thumb/e0d9dd35c5.jpg?1400478209" }}, "ids": { "trakt": 6, "slug": "the-dark-knight-2008", "imdb": "tt0468569", "tmdb": 155 } } } ])}} end] do
      [
        %Trakt.Movie{
          title:        "TRON: Legacy",
          year:         2010,
          genres:       ["action"],
          overview:     "an overview",
          trailer:      "link-to-youtube",
          runtime:      175,
          poster:       %Trakt.Poster{
            full:   "https://walter.trakt.us/images/movies/000/000/001/posters/full/e0d9dd35c5.jpg?1400478209",
            medium: "https://walter.trakt.us/images/movies/000/000/001/posters/medium/e0d9dd35c5.jpg?1400478209",
            thumb:  "https://walter.trakt.us/images/movies/000/000/001/posters/thumb/e0d9dd35c5.jpg?1400478209"
          },
          imdb_id:      "tt1104001",
          trakt_id:     1
        },
        %Trakt.Movie{
          title:        "The Dark Knight",
          year:         2008,
          genres:       ["science fiction"],
          overview:     "an overview",
          trailer:      "link-to-youtube",
          runtime:      210,
          poster:       %Trakt.Poster{
            full:   "https://walter.trakt.us/images/movies/000/000/001/posters/full/e0d9dd35c5.jpg?1400478209",
            medium: "https://walter.trakt.us/images/movies/000/000/001/posters/medium/e0d9dd35c5.jpg?1400478209",
            thumb:  "https://walter.trakt.us/images/movies/000/000/001/posters/thumb/e0d9dd35c5.jpg?1400478209"
          },
          imdb_id:      "tt0468569",
          trakt_id:     6
        }
      ]  = Trakt.wished_movies(user)
    end
  end
end
