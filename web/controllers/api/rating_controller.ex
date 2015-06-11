defmodule Movies.API.RatingController do
  use Movies.Web, :controller

  plug :action

  def index(conn, %{"imdb_id" => imdb_id}) do
    render(conn, "index.json", ratings: User.find_all |> Enum.map(fn (user) ->
      rating = Trakt.rating(user, imdb_id)
      %{
        "username" => user.username,
        "name"     => user.profile.name,
        "rating"   => rating.rating,
      }
    end))
  end

  def create(conn, %{"imdb_id" => imdb_id, "rating" => rating, "username" => username}) do
    Trakt.rate(User.find_by_username!(username), imdb_id, String.to_integer(rating))
    redirect(conn, to: api_rating_path(conn, :index, imdb_id))
  end
end
