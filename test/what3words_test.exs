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
end
