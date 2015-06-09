defmodule Mix.Tasks.SetLanguagesPreferenceTest do
  use ExUnit.Case

  import Mock

  setup do
    client = Exredis.start_using_connection_string(Application.get_env(:movies, :redis_url))
    client |> Exredis.query(["FLUSHDB"])

    :ok
  end

  test "set languages preference when environment variable is set" do
    System.put_env("LANGUAGES_PREFERENCE", "english,spanish")
    Mix.Tasks.SetLanguagesPreference.run([])
    ["spanish", "english"] = LanguagePreference.find_all
  end

  test "does not set anything when environment variable is not set" do
    with_mock Mix.shell, [info: fn(_) -> end] do
      System.delete_env("LANGUAGES_PREFERENCE")
      [] = LanguagePreference.find_all
      Mix.Tasks.SetLanguagesPreference.run([])
      [] = LanguagePreference.find_all
    end
  end
end
