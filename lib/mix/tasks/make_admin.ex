defmodule Mix.Tasks.MakeAdmin do
  use Mix.Task

  @shortdoc "To set a user as admin."

  def run(_) do
    case System.get_env("ADMIN_EMAIL") do
      email when is_binary(email) ->
        user = make_user_admin(find_user(System.get_env("ADMIN_EMAIL")))
        {:ok, _} = User.save(user)
      _ -> Mix.shell.info("environment variable ADMIN_EMAIL is required")
    end
  end

  defp find_user(email) do
    case User.find_by_email(email) do
      {:ok, user} -> user
      {:error}    -> %User{email: email}
    end
  end

  defp make_user_admin(user) do
    %User {profile: profile} = user
    profile = %{profile | roles: profile.roles ++ ["admin"] |> Enum.uniq}

    %{user | profile: profile}
  end
end
