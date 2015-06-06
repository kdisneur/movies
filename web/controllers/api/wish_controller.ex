defmodule Movies.API.WishController do
  use Movies.Web, :controller

  plug :action

  def create(conn, %{"imdb_id" => imdb_id}) do
    Trakt.wish(conn.assigns[:user], imdb_id)

    conn |> put_resp_content_type("text/plain")
         |> send_resp(201, ~s({ "success": true }))
  end
end
