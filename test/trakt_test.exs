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
                              ^expected_body -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/good_oauth_token.json")}}
                              _              -> {:error}
                            end
                          end,
                          get:  fn("https://api-v2launch.trakt.tv/users/settings", %{"Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx", "Content-Type" => "application/json"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/user_settings.json")}} end] do
      {:error, "Not authorized user"} = Trakt.login("good_code")
      User.save(%User{username: "neo"})
      {:ok, %User{profile: %Profile{name: "Neo", trakt_token: "good-token"}}} = Trakt.login("good_code")
    end
  end

  test "login with incorrect code" do
    with_mock HTTPoison, [post: fn("https://api-v2launch.trakt.tv/oauth/token", body, %{"Content-Type" => "application/json"}) ->
                                  expected_body = Poison.Encoder.encode(%{client_id: "xxxx-xxxx-xxxx-xxxx", client_secret: "yyyy-yyyy-yyyy-yyyy", code: "bad_code", grant_type: :authorization_code, redirect_uri: "http://test.dev/auth/trakt"}, %{})
                                  case body do
                                    ^expected_body -> {:ok, %HTTPoison.Response{status_code: 401, body: File.read!("test/fixtures/trakt/bad_oauth_token.json")}}
                                    _              -> {:error}
                                  end
                                end] do
      {:error, "long explanation"} = Trakt.login("bad_code")
    end
  end

  test "add a new movie in user's collection" do
    with_mock HTTPoison, [post: fn(url, body, headers) ->
                                  case {url, headers} do
                                    {"https://api-v2launch.trakt.tv/sync/collection", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}} ->
                                      expected_body = Poison.Encoder.encode(%{"movies" => [%{ "ids" => %{"imdb" => "tt1104001"}}]}, %{})
                                      case body do
                                        ^expected_body -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/own_movie.json")}}
                                        _ -> nil
                                      end
                                    {"https://api-v2launch.trakt.tv/users/neo/lists/wish-list/items/remove", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}} ->
                                      expected_body = Poison.Encoder.encode(%{"movies" => [%{ "ids" => %{"imdb" => "tt1104001"}}]}, %{})
                                      case body do
                                        ^expected_body -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/unwish_movie.json")}}
                                        _ -> nil
                                     end
                                 end
                               end
                         ] do
       %{"added" => %{"movies" => 1}} = Trakt.own(user, "tt1104001")
    end
  end

  test "add new movies in user's collection" do
    with_mock HTTPoison, [post: fn(url, body, headers) ->
                                  case {url, headers} do
                                    {"https://api-v2launch.trakt.tv/sync/collection", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}} ->
                                      expected_body = Poison.Encoder.encode(%{"movies" => [%{ "ids" => %{"imdb" => "tt1104001"}}, %{ "ids" => %{"imdb" => "tt1104002"}}]}, %{})
                                      case body do
                                        ^expected_body -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/own_movies.json")}}
                                        _ -> nil
                                      end
                                    {"https://api-v2launch.trakt.tv/users/neo/lists/wish-list/items/remove", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}} ->
                                      expected_body = Poison.Encoder.encode(%{"movies" => [%{ "ids" => %{"imdb" => "tt1104001"}}, %{ "ids" => %{"imdb" => "tt1104002"}}]}, %{})
                                      case body do
                                        ^expected_body -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/unwish_movies.json")}}
                                        _ -> nil
                                     end
                                 end
                               end
                         ] do
       %{"added" => %{"movies" => 2}} = Trakt.own(user, ["tt1104001", "tt1104002"])
    end
  end

  test "fetch movies for user" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/users/neo/collection/movies?extended=full,images", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/user_movies.json")}} end] do
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
                                    ^expected_body -> {:ok, %HTTPoison.Response{status_code: 201, body: File.read!("test/fixtures/trakt/add_rating.json")}}
                                    _              -> nil
                                  end
                                end] do
      %{"added" => %{"movies" => 1}} = Trakt.rate(user, "tt1104001", 8)
    end
  end

  test "find user rating for an existing movie" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/sync/ratings/movies", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/find_rating.json")}} end] do
      %Trakt.Rating{rating: 10, imdb_id: "tt1104001"} = Trakt.rating(user, "tt1104001")
    end
  end

  test "find user rating for a non exising movie" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/sync/ratings/movies", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/find_rating.json")}} end] do
      %Trakt.Rating{rating: 0, imdb_id: "tt1101337"} = Trakt.rating(user, "tt1101337")
    end
  end

  test "find all user ratings" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/sync/ratings/movies", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/find_rating.json")}} end] do
      [
        %Trakt.Rating{rating: 10, imdb_id: "tt1104001"},
        %Trakt.Rating{rating:  8, imdb_id: "tt0468569"}
      ] = Trakt.ratings(user)
    end
  end

  test "search a film" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/search?type=movie&query=film+with+spaces", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/search_movie.json")}} end] do
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
                                   ^expected_body -> {:ok, %HTTPoison.Response{status_code: 201, body: File.read!("test/fixtures/trakt/wish_movie.json")}}
                                   _ -> nil
                                 end
                               end] do
       %{"added" => %{"movies" => 1}} = Trakt.wish(user, "tt1104001")
    end
  end

  test "wish list" do
    with_mock HTTPoison, [get: fn("https://api-v2launch.trakt.tv/users/neo/lists/wish-list/items?extended=full,images", %{"Content-Type" => "application/json", "Authorization" => "Bearer good-token", "trakt-api-version" => 2, "trakt-api-key" => "xxxx-xxxx-xxxx-xxxx"}) -> {:ok, %HTTPoison.Response{status_code: 200, body: File.read!("test/fixtures/trakt/wish_list.json")}} end] do
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
