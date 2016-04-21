defmodule What3Words.TestClient do
  @base_url "https://api.what3words.com"

  def get!("/w3w?" <> query),      do: words(query |> URI.decode_query)
  def get!("/position?" <> query), do: coordinates(query |> URI.decode_query)
  def get!("/get-languages?" <> query), do: languages(query |> URI.decode_query)

  defp words(%{"string" => "word.not.found"}) do
    %{status_code: 200, body: %{error: "4", message: "nah"}}
  end
  defp words(%{"string" => "home.index.raft"}) do
    %{status_code: 200, body: %{
      language: "en",
      position: [40.723008, -74.199598],
      type: "3 words",
      words: ["home", "index", "raft"]
    }}
  end

  defp coordinates(%{"position" => "123141.2, 12423523.1"}) do
    %{status_code: 200, body: %{error: "4", message: "nah"}}
  end
  defp coordinates(%{"position" => "40.723008, -74.199598"}) do
    %{status_code: 200, body: %{
      language: "en",
      position: [40.723008, -74.199598],
      words: ["home", "index", "raft"]
    }}
  end

  defp languages(_query) do
    %{status_code: 200, body: %{languages: [
      %{"code" => "en", "name" => "English"},
      %{"code" => "fr", "name" => "French"}
    ]}}
  end
end
