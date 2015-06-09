defmodule LanguagePreference do
  @namespace "languages"
  @redis_url Application.get_env(:movies, :redis_url)

  def find_all, do: client |> Exredis.query(["SMEMBERS", @namespace])

  def remove(language) when is_binary(language), do: remove([language])
  def remove([]), do: nil
  def remove([language|tail]) do
    client |> Exredis.query(["SREM", @namespace, language])
    remove(tail)
  end

  def save(language) when is_binary(language), do: save([language])
  def save([]), do: nil
  def save([language|tail]) do
    client |> Exredis.query(["SADD", @namespace, language])
    save(tail)
  end

  defp client, do: Exredis.start_using_connection_string(@redis_url)
end
