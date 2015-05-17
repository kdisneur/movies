defmodule Movies.TraktAuthenticationController do
  use Movies.Web, :controller

  plug :action

  def create(conn, %{ "code" => code }) do
    case Trakt.login(code) do
      { :ok, user }       ->
        conn = put_session(conn, :username, user.username)
        redirect(conn, to: owned_movies_path(conn, :index))
      { :error, message } -> conn |> put_flash(:error, message) |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params), do: conn |> delete_session(:username) |> put_flash(:success, "You have been signed out.") |> redirect(to: page_path(conn, :index))
end
