defmodule What3WordsTest do
  use ExUnit.Case
  doctest What3Words

  test "forward({word, not, found}) returns {:error, :coordinates_not_found}" do
    assert What3Words.forward(
      {"word", "not", "found"}
    ) == {:error, :coordinates_not_found}
  end

  test "forward({home, index, raft}) returns {:ok, {29.396521, -98.661698}}" do
    assert What3Words.forward(
      {"home", "index", "raft"}
    ) == {:ok, %{lat: 40.723008, lng: -74.199598}}
  end

  test "reverse({123141.2, 12423523.1}) returns {:error, :words_not_found}" do
    assert What3Words.reverse(
      {123141.2, 12423523.1}
    ) == {:error, :words_not_found}
  end

  test "reverse({40.723008, -74.199598}) returns {:ok, {home, index, raft}}" do
    assert What3Words.reverse(
      {40.723008, -74.199598}
    ) == {:ok, "home.index.raft"}
  end

  test "languages() returns {:ok, [en, fr]}" do
    assert What3Words.languages == {:ok, ["en", "fr"]}
  end

  test "autosuggest(home.index.r, en) returns the correct suggestions" do
    expected = [
      %What3Words.Suggestion{
        distance: 14, rank: 1,
        words: "plan.clips.area", score: 95.994349285319,
        place: "Brixton Hill, London", country: "gb",
        geometry: %{
          lng: -0.140382,
          lat: 51.429293
        }
      }]
    assert What3Words.autosuggest("home.index.r", "en") == {:ok, expected}
  end

  test "autosuggest with clip on radius returns the correct suggestions" do
    expected = [
      %What3Words.Suggestion{
        distance: 15, rank: 2,
        words: "plan.clips.area", score: 95.994349285319,
        place: "Brixton Hill, London", country: "gb",
        geometry: %{
          lng: -0.140382,
          lat: 51.429293
        }
      }]
    assert What3Words.autosuggest("home.index.r", "en", %{clip: %{radius: {1, 1, 10}}}) == {:ok, expected}
  end

  test "autosuggest with clip on bbox returns the correct suggestions" do
    expected = [
      %What3Words.Suggestion{
        distance: 16, rank: 3,
        words: "plan.clips.area", score: 95.994349285319,
        place: "Brixton Hill, London", country: "gb",
        geometry: %{
          lng: -0.140382,
          lat: 51.429293
        }
      }]
    assert What3Words.autosuggest("home.index.r", "en", %{clip: %{bbox: {1, 1, -1, -1}}}) == {:ok, expected}
  end

  test "autosuggest with clip on focus returns the correct suggestions" do
    expected = [
      %What3Words.Suggestion{
        distance: 17, rank: 4,
        words: "plan.clips.area", score: 95.994349285319,
        place: "Brixton Hill, London", country: "gb",
        geometry: %{
          lng: -0.140382,
          lat: 51.429293
        }
      }]
    assert What3Words.autosuggest("home.index.r", "en", %{clip: %{focus: 20}}) == {:ok, expected}
  end

  test "autosuggest with clip set to false returns the correct suggestions" do
    expected = [
      %What3Words.Suggestion{
        distance: 20, rank: 10,
        words: "plan.clips.area", score: 95.994349285319,
        place: "Brixton Hill, London", country: "gb",
        geometry: %{
          lng: -0.140382,
          lat: 51.429293
        }
      }]
    assert What3Words.autosuggest("home.index.r", "en", %{clip: false}) == {:ok, expected}
  end

  test "autosuggest with focus parameter returns the correct suggestions" do
    expected = [
      %What3Words.Suggestion{
        distance: 3, rank: 100,
        words: "plan.clips.area", score: 95.994349285319,
        place: "Brixton Hill, London", country: "gb",
        geometry: %{
          lng: -0.140382,
          lat: 51.429293
        }
      }]
    assert What3Words.autosuggest("home.index.r", "en", %{focus: {1,1}}) == {:ok, expected}
  end

  test "autosuggest with focus and clip returns the correct suggestions" do
    expected = [
      %What3Words.Suggestion{
        distance: 200, rank: 1,
        words: "plan.clips.area", score: 95.994349285319,
        place: "Brixton Hill, London", country: "gb",
        geometry: %{
          lng: -0.140382,
          lat: 51.429293
        }
      }]
    assert What3Words.autosuggest("home.index.r", "en", %{clip: %{focus: 10}, focus: {2,2}}) == {:ok, expected}
  end
end
