defmodule User do
  @namespace "users"
  @redis_url Application.get_env(:movies, :redis_url)

  defstruct username: nil, profile: %Profile{}

  def find_all, do: client |> Exredis.query(["HGETALL", @namespace]) |> build_users

  def find_by_username!(username) do
    case find_by_username(username) do
      {:ok, user} -> user
      {:error}    -> raise "Username #{username} does not exist"
    end
  end

  def find_by_username(username) when username == nil, do: {:error}
  def find_by_username(username) when is_binary(username) do
    case find_profile(username) do
      {:ok, raw_profile} -> {:ok, build_user(username, raw_profile)}
      {:error}           -> {:error}
    end
  end

  def find_by_trakt_token(trakt_token) when is_binary(trakt_token) do
    case find_all |> Enum.find(fn user -> user.profile.trakt_token == trakt_token end) do
      nil  -> {:error}
      user -> user
    end
  end

  def is_admin?(%User{profile: %Profile{roles: roles}}), do: Enum.member?(roles, "admin")

  def remove(%User{username: username}), do: remove(username)
  def remove(username) do
    case client |> Exredis.query(["HDEL", @namespace, username]) do
      "1" -> {:ok}
      "0" -> {:error}
    end
  end

  def save(user=%User{username: username}) when username != "" do
    case client |> Exredis.query(["HSET", @namespace, user.username, Poison.Encoder.encode(user.profile, [])]) do
      code when code == "0" or code == "1" -> {:ok, user}
      _ -> {:error}
    end
  end
  def save(%User{}), do: {:error}

  defp build_profile(raw_profile), do: Poison.decode!(raw_profile, as: Profile)

  defp build_users(data), do: build_users(data, [])
  defp build_users([username, raw_profile|tail], users), do: build_users(tail, users ++ [build_user(username, raw_profile)])
  defp build_users([], users), do: users

  defp build_user(username, raw_profile), do: %User{username: username, profile: build_profile(raw_profile)}

  defp client, do: Exredis.start_using_connection_string(@redis_url)

  defp find_profile(username) do
    case client |> Exredis.query(["HGET", @namespace, username]) do
      :undefined  -> {:error}
      raw_profile -> {:ok, raw_profile}
    end
  end
end
