defmodule TestHelper do
  def suggestion_with_words(words) do
    %What3Words.Suggestion{
      distance: 1,
      rank: 1,
      words: words,
      score: 1,
      place: "King's College, Cambridge",
      country: "gb",
      geometry: %{
        lng: 1.000000,
        lat: 1.000000
      }
    }
  end
end

ExUnit.start()
