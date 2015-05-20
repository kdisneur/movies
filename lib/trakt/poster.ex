defmodule Trakt.Poster do
  defstruct thumb: nil, medium: nil, full: nil

  def build(%{"poster" => %{"full" => full, "medium" => medium, "thumb" => thumb}}) do
    %Trakt.Poster{thumb: thumb, medium: medium, full: full}
  end
end
