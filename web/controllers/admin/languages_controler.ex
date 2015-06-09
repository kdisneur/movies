defmodule Movies.Admin.LanguagesController do
  use Movies.Web, :controller

  plug :action

  def index(conn, _params), do: conn |> render("index.html", languages: LanguagePreference.find_all)

  def create(conn, %{"language" => %{ "name" => language }}) do
    LanguagePreference.save(language)

    conn
    |> put_flash(:success, "Language #{language} has been added.")
    |> redirect(to: languages_path(conn, :index))
    |> halt
  end

  def delete(conn, %{"id" => language}) do
    LanguagePreference.remove(language)

    conn
    |> put_flash(:success, "Language #{language} has been removed.")
    |> redirect(to: languages_path(conn, :index))
    |> halt
  end
end
