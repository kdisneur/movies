defmodule Mix.Tasks.MakeAdmin do
  use Mix.Task

  @shortdoc "To set a user as admin."

  def run(_) do
    case System.get_env("ADMIN_USERNAME") do
      username when is_binary(username) ->
        user = make_user_admin(find_user(username))
        {:ok, _} = User.save(user)
      _ -> Mix.shell.info("environment variable ADMIN_USERNAME is required")
    end
  end

  defp find_user(username) do
    case User.find_by_username(username) do
      {:ok, user} -> user
      {:error}    -> %User{username: username}
    end
  end

  defp make_user_admin(user) do
    %User {profile: profile} = user
    profile = %{profile | roles: profile.roles ++ ["admin"] |> Enum.uniq}

    %{user | profile: profile}
  end
end
