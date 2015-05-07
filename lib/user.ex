defmodule User do
  @namespace "users"
  @redis_url Application.get_env(:movies, :redis_url)

  defstruct email: nil, profile: %Profile{}

  def find_all, do: client |> Exredis.query(["HGETALL", @namespace]) |> build_users

  def find_by_email(email) when is_binary(email) do
    case find_profile(email) do
      {:ok, raw_profile} -> {:ok, build_user(email, raw_profile)}
      {:error}           -> {:error}
    end
  end

  def remove(%User{email: email}), do: remove(email)
  def remove(email) do
    case client |> Exredis.query(["HDEL", @namespace, email]) do
      "1" -> {:ok}
      "0" -> {:error}
    end
  end

  def save(user=%User{}) do
    case client |> Exredis.query(["HSET", @namespace, user.email, Poison.Encoder.encode(user.profile, [])]) do
      code when code == "0" or code == "1" -> {:ok, user}
      _ -> {:error}
    end
  end

  defp build_profile(raw_profile), do: Poison.decode!(raw_profile, as: Profile)

  defp build_users(data), do: build_users(data, [])
  defp build_users([email, raw_profile|tail], users), do: build_users(tail, users ++ [build_user(email, raw_profile)])
  defp build_users([], users), do: users

  defp build_user(email, raw_profile), do: %User{email: email, profile: build_profile(raw_profile)}

  defp client, do: Exredis.start_using_connection_string(@redis_url)

  defp find_profile(email) do
    case client |> Exredis.query(["HGET", @namespace, email]) do
      :undefined  -> {:error}
      raw_profile -> {:ok, raw_profile}
    end
  end
end
