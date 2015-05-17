defmodule Movies.Admin.MembersController do
  use Movies.Web, :controller

  plug :action

  def index(conn, _params), do: render(conn, "index.html", members: User.find_all)
  def delete(conn, %{ "id" => username }) do
    case User.remove(username) do
      {:ok}    -> conn |> put_flash(:success, "User #{username} has been removed") |> redirect(to: members_path(conn, :index)) |> halt
      {:error} -> conn |> put_flash(:error, "User #{username} has not been removed") |> redirect(to: members_path(conn, :index)) |> halt
    end
  end
end
