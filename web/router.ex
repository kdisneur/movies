defmodule Movies.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug Plug.FetchUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.CheckAPIAuthentication
    plug Plug.FetchUser
  end

  pipeline :authenticated do
    plug Plug.CheckAuthentication
  end

  scope "/api", Movies, as: :api do
    pipe_through :api

    get  "/movies/owned",  API.OwnedMoviesController,  :index
    get  "/movies/search", API.SearchMoviesController, :index
    get  "/movies/wished", API.WishedMoviesController, :index
    get  "/movies/ratings/:imdb_id",  API.RatingController, :index
    post "/movies/ratings/:imdb_id",  API.RatingController, :create
    get  "/movies/subtitle/:imdb_id", API.SubtitleController, :show
    get  "/movies/torrent/:imdb_id",  API.TorrentController,  :show
    post "/movies/wish/:imdb_id", API.WishController, :create
  end

  scope "/", Movies do
    pipe_through :browser

    get "/", PageController, :index
    get "/auth/trakt", TraktAuthenticationController, :create

    scope "/" do
      pipe_through :authenticated

      get "/movies/owned",  OwnedMoviesController,  :index
      get "/movies/search", SearchMoviesController, :index
      get "/movies/wished", WishedMoviesController, :index
      delete "/sign_out",   TraktAuthenticationController, :delete

      scope "/admin", Admin do
        resources "/members", MembersController, only: [:index, :create, :delete]
      end
    end
  end
end
