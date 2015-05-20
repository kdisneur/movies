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

    get "/movies/owned", API.OwnedMoviesController, :index
    get "/movies/torrent/:imdb_id", API.TorrentController, :show
    get "/movies/subtitle/:imdb_id", API.SubtitleController, :show
  end

  scope "/", Movies do
    pipe_through :browser

    get "/", PageController, :index
    get "/auth/trakt", TraktAuthenticationController, :create

    scope "/" do
      pipe_through :authenticated

      get "/movies/owned", OwnedMoviesController, :index
      delete "/sign_out", TraktAuthenticationController, :delete

      scope "/admin", Admin do
        resources "/members", MembersController, only: [:index, :create, :delete]
      end
    end
  end
end
