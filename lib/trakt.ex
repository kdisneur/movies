defmodule Trakt do
  def authorize_url do
    Trakt.URL.build("/oauth/authorize", %{
      response_type: :code,
      client_id:     Trakt.Config.client_id,
      redirect_uri:  Trakt.Config.redirect_uri
    })
  end

  def login(code) do
    result = Trakt.Request.post(Trakt.URL.build("/oauth/token"), %{
      client_id:     Trakt.Config.client_id,
      client_secret: Trakt.Config.client_secret,
      code:          code,
      grant_type:    :authorization_code,
      redirect_uri:  Trakt.Config.redirect_uri,
    })

    case result do
      %{ "access_token" => trakt_token }      -> find_and_update_user(trakt_token)
      %{ "error_description" => description } -> {:error, description}
    end
  end

  defp find_and_update_user(trakt_token) do
    %{ "user" => trakt_settings } = Trakt.Request.get(Trakt.URL.build("/users/settings"), %{
      "Authorization"     => "Bearer #{trakt_token}",
      "trakt-api-version" => Trakt.Config.api_version,
      "trakt-api-key"     => Trakt.Config.client_id
    })

    case User.find_by_username(trakt_settings["username"]) do
      {:error}    -> {:error, "Not authorized user"}
      {:ok, user} -> User.save(%User{user | profile: %Profile{user.profile | name: trakt_settings["name"], trakt_token: trakt_token}})
    end
  end
end
