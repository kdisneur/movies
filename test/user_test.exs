defmodule UserTest do
  use ExUnit.Case

  setup do
    client = Exredis.start_using_connection_string(Application.get_env(:movies, :redis_url))
    client |> Exredis.query(["FLUSHDB"])

    :ok
  end

  test "find all when there is users" do
    neo     = %User{username: "neo", profile: %Profile{name: "Neo", roles: ["admin"]}}
    User.save(neo)
    trinity = %User{username: "trinity", profile: %Profile{name: "Trinity"}}
    User.save(trinity)

    assert User.find_all == [neo, trinity]
  end

  test "find all when there is no users" do
    assert User.find_all == []
  end

  test "find non existent user by username" do
    assert User.find_by_username("neo") == {:error}
  end

  test "find existent user by username" do
    user = %User{username: "neo", profile: %Profile{name: "Neo", roles: ["admin"]}}
    {:ok, user} = User.save(user)

    assert User.find_by_username(user.username) == {:ok, user}
  end

  test "is_admin? when user is an admin" do
    assert User.is_admin?(%User{username: "neo", profile: %Profile{roles: ["admin"]}}) == true
  end

  test "is_admin? when user is not an admin" do
    assert User.is_admin?(%User{username: "neo", profile: %Profile{roles: ["not_admin"]}}) == false
  end

  test "remove a user" do
    user = %User{username: "neo", profile: %Profile{name: "Neo", roles: ["admin"]}}
    {:ok, user} = User.save(user)

    assert User.remove(user) == {:ok}
  end

  test "remove a non existent user" do
    user = %User{username: "neo", profile: %Profile{name: "Neo", roles: ["admin"]}}

    assert User.remove(user) == {:error}
  end

  test "remove a user by username" do
    user = %User{username: "neo", profile: %Profile{name: "Neo", roles: ["admin"]}}
    {:ok, user} = User.save(user)

    assert User.remove(user.username) == {:ok}
  end

  test "remove a non existent user by username" do
    assert User.remove("neo") == {:error}
  end

  test "saves a user" do
    user = %User{username: "neo", profile: %Profile{name: "Neo", roles: ["admin"]}}
    assert User.save(user) == {:ok, user}
  end
end
