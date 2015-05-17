defmodule Movies.LayoutView do
  use Movies.Web, :view

  def alert_message_class(:error), do: "alert-danger"
  def alert_message_class(type), do: "alert-#{type}"

  def active_view_class(conn, path) do
    current_path = "/" <> (conn.path_info |> Enum.join("/"))
    case current_path == path do
      true -> "active"
      _    -> ""
    end
  end
end
