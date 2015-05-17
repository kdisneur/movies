defmodule Movies.Admin.MembersController do
  use Movies.Web, :controller

  plug :action

  def index(conn, _params), do: render(conn, "index.html", members: User.find_all)

  def create(conn, %{ "user" => %{ "username" => username }}) do
    case User.save(%User{username: username}) do
      {:ok, _} -> conn |> put_flash(:success, "User #{username} has been added.") |> redirect(to: members_path(conn, :index)) |> halt
      {:error} -> conn |> put_flash(:error, "User #{username} has not been added.") |> render("index.html", username: username, members: User.find_all) |> halt
    end
  end

  def delete(conn, %{ "id" => username }) do
    conn = case User.remove(username) do
      {:ok}    -> conn |> put_flash(:success, "User #{username} has been removed")
      {:error} -> conn |> put_flash(:error, "User #{username} has not been removed")
    end

   conn |> redirect(to: members_path(conn, :index)) |> halt
  end
end
