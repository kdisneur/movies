defmodule Mix.Tasks.MakeAdminTest do
  use ExUnit.Case

  setup do
    client = Exredis.start_using_connection_string(Application.get_env(:movies, :redis_url))
    client |> Exredis.query(["FLUSHDB"])

    :ok
  end

  test "set user as admin when environment variable is set and email already exists" do
    {:ok, _} = User.save(%User{email: "neo@matrix.com"})
    System.put_env("ADMIN_EMAIL", "neo@matrix.com")

    {:ok, _} = User.find_by_email("neo@matrix.com")
    Mix.Tasks.MakeAdmin.run([])
    {:ok, user} = User.find_by_email("neo@matrix.com")
    ["admin"] = user.profile.roles
  end

  test "set user as admin when environment variable is set and email does not exist" do
    System.put_env("ADMIN_EMAIL", "neo@matrix.com")

    {:error} = User.find_by_email("neo@matrix.com")
    Mix.Tasks.MakeAdmin.run([])
    {:ok, user} = User.find_by_email("neo@matrix.com")
    ["admin"] = user.profile.roles
  end

  test "set user as admin when environment variable is not set" do
    System.delete_env("ADMIN_EMAIL")
    [] = User.find_all
    Mix.Tasks.MakeAdmin.run([])
    [] = User.find_all
  end
end
