defmodule LanguagePreferenceTest do
  use ExUnit.Case

  setup do
    Exredis.start_using_connection_string(Application.get_env(:movies, :redis_url)) |> Exredis.query(["FLUSHDB"])
    :ok
  end

  test "language preferences can be saved" do
    assert [] == LanguagePreference.find_all
    LanguagePreference.save(["french", "english"])
    assert ["english", "french"] == LanguagePreference.find_all
  end
end
