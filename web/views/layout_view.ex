defmodule Movies.LayoutView do
  use Movies.Web, :view

  def alert_message_class(:error), do: "alert-danger"
  def alert_message_class(type), do: "alert-#{type}"

  def alert_message_title(:error), do: "Outch!"
  def alert_message_title(:success), do: "Yeah!"

  def active_view_class(conn, path) do
    current_path = "/" <> (conn.path_info |> Enum.join("/"))
    case current_path == path do
      true -> "active"
      _    -> ""
    end
  end
end
