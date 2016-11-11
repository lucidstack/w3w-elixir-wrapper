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
    %{status_code: 200, body: %{suggestions: [
      %{
        "distance" => 15,
        "rank" => 2,
        "words" => "plan.clips.area",
        "score" => 95.994349285319,
        "place" => "Brixton Hill, London",
        "geometry" => %{
          "lng" => -0.140382,
          "lat" => 51.429293
        },
        "country" => "gb"
      }]
    }}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "clip" => "focus(20)"}) do
    %{status_code: 200, body: %{suggestions: [
      %{
        "distance" => 17,
        "rank" => 4,
        "words" => "plan.clips.area",
        "score" => 95.994349285319,
        "place" => "Brixton Hill, London",
        "geometry" => %{
          "lng" => -0.140382,
          "lat" => 51.429293
        },
        "country" => "gb"
      }]
    }}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "clip" => "none"}) do
    %{status_code: 200, body: %{suggestions: [
      %{
        "distance" => 20,
        "rank" => 10,
        "words" => "plan.clips.area",
        "score" => 95.994349285319,
        "place" => "Brixton Hill, London",
        "geometry" => %{
          "lng" => -0.140382,
          "lat" => 51.429293
        },
        "country" => "gb"
      }]
    }}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "focus" => "1,1"}) do
    %{status_code: 200, body: %{suggestions: [
      %{
        "distance" => 3,
        "rank" => 100,
        "words" => "plan.clips.area",
        "score" => 95.994349285319,
        "place" => "Brixton Hill, London",
        "geometry" => %{
          "lng" => -0.140382,
          "lat" => 51.429293
        },
        "country" => "gb"
      }]
    }}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "focus" => "2,2", "clip" => "focus(10)"}) do
    %{status_code: 200, body: %{suggestions: [
      %{
        "distance" => 200,
        "rank" => 1,
        "words" => "plan.clips.area",
        "score" => 95.994349285319,
        "place" => "Brixton Hill, London",
        "geometry" => %{
          "lng" => -0.140382,
          "lat" => 51.429293
        },
        "country" => "gb"
      }]
    }}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r", "clip" => "bbox(1,1,-1,-1)"}) do
    %{status_code: 200, body: %{suggestions: [
      %{
        "distance" => 16,
        "rank" => 3,
        "words" => "plan.clips.area",
        "score" => 95.994349285319,
        "place" => "Brixton Hill, London",
        "geometry" => %{
          "lng" => -0.140382,
          "lat" => 51.429293
        },
        "country" => "gb"
      }]
    }}
  end

  def autosuggest(%{"lang" => "en", "addr" => "home.index.r"}) do
    %{status_code: 200, body: %{suggestions: [
      %{
        "distance" => 14,
        "rank" => 1,
        "words" => "plan.clips.area",
        "score" => 95.994349285319,
        "place" => "Brixton Hill, London",
        "geometry" => %{
          "lng" => -0.140382,
          "lat" => 51.429293
        },
        "country" => "gb"
      }]
    }}
  end
end
