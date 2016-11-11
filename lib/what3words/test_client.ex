defmodule What3Words.TestClient do
  @moduledoc ~S"""
  A noop client for tests; it is a mock of `What3Words.Client`.
  """

  @base_url "https://api.what3words.com"

  def get!("/forward?" <> query),    do: words(query |> URI.decode_query)
  def get!("/reverse" <> query),     do: coordinates(query |> URI.decode_query)
  def get!("/languages?" <> query),  do: languages(query |> URI.decode_query)
  def get!("/autosuggest" <> query), do: autosuggest(query |> URI.decode_query)


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


  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "clip" => "radius(1,1,10)"}) do
    body = %{suggestions: [suggestion_with_words("clip.radius.request")]}
    %{status_code: 200, body: body}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "focus" => "1,1", "clip" => "focus(10)"}) do
    body = %{suggestions: [suggestion_with_words("clip.focus.request")]}
    %{status_code: 200, body: body}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "clip" => "none"}) do
    body = %{suggestions: [suggestion_with_words("clip.none.request")]}
    %{status_code: 200, body: body}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "clip" => "bbox(1,1,-1,-1)"}) do
    body = %{suggestions: [suggestion_with_words("clip.bbox.request")]}
    %{status_code: 200, body: body}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "focus" => "1,1"}) do
    body = %{suggestions: [suggestion_with_words("focus.option.request")]}
    %{status_code: 200, body: body}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r"}) do
    body = %{suggestions: [suggestion_with_words("no.options.request")]}
    %{status_code: 200, body: body}
  end

  defp suggestion_with_words(words) do
    %{
      "distance" => 1,
      "rank" => 1,
      "words" => words,
      "score" => 1,
      "place" => "King's College, Cambridge",
      "country" => "gb",
      "geometry" => %{
        "lng" => 1.000000,
        "lat" => 1.000000
      }
    }
  end
end
