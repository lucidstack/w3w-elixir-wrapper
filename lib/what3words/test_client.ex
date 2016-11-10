defmodule What3Words.TestClient do
  @moduledoc ~S"""
  A noop client for tests; mocks `What3Words.Client`.
  """

  @base_url "https://api.what3words.com"

  def get!("/forward?" <> query),      do: words(query |> URI.decode_query)
  def get!("/reverse" <> query), do: coordinates(query |> URI.decode_query)
  def get!("/get-languages?" <> query), do: languages(query |> URI.decode_query)

  defp words(%{"addr" => "word.not.found"}) do
    %{status_code: 200, body: %{error: "4", message: "nah"}}
  end
  defp words(%{"addr" => "home.index.raft"}) do
    %{status_code: 200, body: %{
      language: "en",
      geometry: %{"lat" => 40.723008, "lng" => -74.199598},
      words: "home.index.raft"
    }}
  end

  defp coordinates(%{"coords" => "123141.2,12423523.1"}) do
    %{status_code: 200, body: %{error: "4", message: "nah"}}
  end
  defp coordinates(%{"coords" => "40.723008,-74.199598"}) do
    %{status_code: 200, body: %{
      language: "en",
      geometry: %{"lat" => 40.723008, "lng" => -74.199598},
      words: "home.index.raft"
    }}
  end

  defp languages(_query) do
    %{status_code: 200, body: %{languages: [
      %{"code" => "en", "name_display" => "English"},
      %{"code" => "fr", "name_display" => "French"}
    ]}}
  end
end
