defmodule LanguagePreference do
  @namespace "languages"
  @redis_url Application.get_env(:movies, :redis_url)

  def find_all, do: client |> Exredis.query(["SMEMBERS", @namespace])

  def save([]), do: nil
  def save([language|tail]) do
    client |> Exredis.query(["SADD", @namespace, language])
    save(tail)
  end

  defp client, do: Exredis.start_using_connection_string(@redis_url)
end
