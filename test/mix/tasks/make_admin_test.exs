defmodule Mix.Tasks.MakeAdminTest do
  use ExUnit.Case

  setup do
    client = Exredis.start_using_connection_string(Application.get_env(:movies, :redis_url))
    client |> Exredis.query(["FLUSHDB"])

    :ok
  end

  test "set user as admin when environment variable is set and username already exists" do
    {:ok, _} = User.save(%User{username: "neo"})
    System.put_env("ADMIN_USERNAME", "neo")

    {:ok, _} = User.find_by_username("neo")
    Mix.Tasks.MakeAdmin.run([])
    {:ok, user} = User.find_by_username("neo")
    ["admin"] = user.profile.roles
  end

  test "set user as admin when environment variable is set and username does not exist" do
    System.put_env("ADMIN_USERNAME", "neo")

    {:error} = User.find_by_username("neo")
    Mix.Tasks.MakeAdmin.run([])
    {:ok, user} = User.find_by_username("neo")
    ["admin"] = user.profile.roles
  end

  test "set user as admin when environment variable is not set" do
    System.delete_env("ADMIN_USERNAME")
    [] = User.find_all
    Mix.Tasks.MakeAdmin.run([])
    [] = User.find_all
  end
end
