defmodule What3Words.TestClient do
  @base_url "https://api.what3words.com"

  def get!("/w3w?" <> query),      do: words(query |> URI.decode_query)
  def get!("/position?" <> query), do: coordinates(query |> URI.decode_query)
  def get!("/get-languages?" <> query), do: languages(query |> URI.decode_query)

  defp words(%{"string" => "word.not.found"}) do
    %{status_code: 200, body: %{error: "4", message: "nah"}}
  end
  defp words(%{"string" => "index.home.raft"}) do
    %{status_code: 200, body: %{position: [29.396521, -98.661698]}}
  end

  defp coordinates(%{"position" => "123141.2, 12423523.1"}) do
    %{status_code: 200, body: %{error: "4", message: "nah"}}
  end
  defp coordinates(%{"position" => "29.396521, -98.661698"}) do
    %{status_code: 200, body: %{words: ["index", "home", "raft"]}}
  end

  defp languages(_query) do
    %{status_code: 200, body: %{languages: [
      %{"code" => "en", "name" => "English"},
      %{"code" => "fr", "name" => "French"}
    ]}}
  end
end
