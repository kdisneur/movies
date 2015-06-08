defmodule Movies.Mixfile do
  use Mix.Project

  def project do
    [app: :movies,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(Mix.env)] ++ project_env_specific(Mix.env)
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Movies, []},
     applications: [:phoenix, :cowboy, :dotenv, :logger, :httpoison, :poison, :slim]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps(:production), do: general_deps
  defp deps(env) when env == :dev or env == :test, do: general_deps ++ [{:excoveralls, "~> 0.3"}]

  defp project_env_specific(:production), do: []
  defp project_env_specific(env) when env == :dev or env == :test, do: [test_coverage: [tool: ExCoveralls]]

  defp general_deps do
    [
      {:cowboy, "~> 1.0"},
      {:dotenv, "~> 1.0.0"},
      {:exredis, "~> 0.1.2"},
      {:httpoison, "~> 0.6"},
      {:mock, "~> 0.1.0"},
      {:phoenix, "~> 0.13"},
      {:phoenix_html, "~> 1.0"},
      {:phoenix_live_reload, "~> 0.4"},
      {:poison, "~> 1.4.0"},
      {:slim, github: "kdisneur/elixir-slim"}
    ]
  end
end
