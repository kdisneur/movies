defmodule LanguagePreferenceTest do
  use ExUnit.Case

  setup do
    Exredis.start_using_connection_string(Application.get_env(:movies, :redis_url)) |> Exredis.query(["FLUSHDB"])
    :ok
  end

  test "language preferences can be saved" do
    assert [] == LanguagePreference.find_all
    LanguagePreference.save(["french", "english"])
    LanguagePreference.save("spanish")
    assert ["english", "french", "spanish"] == LanguagePreference.find_all
  end

  test "language preferences can be removed" do
    assert [] == LanguagePreference.find_all
    LanguagePreference.save(["french", "chinese", "english", "spanish"])
    assert ["chinese", "english", "french", "spanish"] == LanguagePreference.find_all
    LanguagePreference.remove(["french", "english"])
    assert ["chinese", "spanish"] == LanguagePreference.find_all
    LanguagePreference.remove(["chinese"])
    assert ["spanish"] == LanguagePreference.find_all
  end
end
