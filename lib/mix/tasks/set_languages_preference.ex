defmodule Mix.Tasks.SetLanguagesPreference do
  use Mix.Task

  @shortdoc "To set languages preference for subtitles"

  def run(_) do
    case System.get_env("LANGUAGES_PREFERENCE") do
      languages when is_binary(languages) -> languages |> String.split(",") |> LanguagePreference.save
      _ -> Mix.shell.info("environment variable LANGUAGES_PREFERENCE is required")
    end
  end
end
