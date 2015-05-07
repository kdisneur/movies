defmodule UserTest do
  use ExUnit.Case

  setup do
    client = Exredis.start_using_connection_string(Application.get_env(:movies, :redis_url))
    client |> Exredis.query(["FLUSHDB"])

    :ok
  end

  test "find all when there is users" do
    neo     = %User{email: "neo@matrix.com", profile: %Profile{firstname: "Neo", roles: ["admin"]}}
    User.save(neo)
    trinity = %User{email: "trinity@matrix.com", profile: %Profile{firstname: "Trinity"}}
    User.save(trinity)

    assert User.find_all == [neo, trinity]
  end

  test "find all when there is no users" do
    assert User.find_all == []
  end

  test "find non existent user by email" do
    assert User.find_by_email("neo@matrix.com") == {:error}
  end

  test "find existent user by email" do
    user = %User{email: "neo@matrix.com", profile: %Profile{firstname: "Neo", roles: ["admin"]}}
    {:ok, user} = User.save(user)

    assert User.find_by_email(user.email) == {:ok, user}
  end

  test "remove a user" do
    user = %User{email: "neo@matrix.com", profile: %Profile{firstname: "Neo", roles: ["admin"]}}
    {:ok, user} = User.save(user)

    assert User.remove(user) == {:ok}
  end

  test "remove a non existent user" do
    user = %User{email: "neo@matrix.com", profile: %Profile{firstname: "Neo", roles: ["admin"]}}

    assert User.remove(user) == {:error}
  end

  test "remove a user by email" do
    user = %User{email: "neo@matrix.com", profile: %Profile{firstname: "Neo", roles: ["admin"]}}
    {:ok, user} = User.save(user)

    assert User.remove(user.email) == {:ok}
  end

  test "remove a non existent user by email" do
    assert User.remove("neo@matrix.com") == {:error}
  end

  test "saves a user" do
    user = %User{email: "neo@matrix.com", profile: %Profile{firstname: "Neo", roles: ["admin"]}}
    assert User.save(user) == {:ok, user}
  end
end
