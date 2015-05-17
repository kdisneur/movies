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
  end

  pipeline :authenticated do
    plug Plug.CheckAuthentication
  end

  scope "/", Movies do
    pipe_through :browser

    get "/", PageController, :index
    get "/auth/trakt", TraktAuthenticationController, :create

    scope "/" do
      pipe_through :authenticated

      get "/movies/owned", OwnedMoviesController, :index
      delete "/sign_out", TraktAuthenticationController, :destroy
    end
  end
end
