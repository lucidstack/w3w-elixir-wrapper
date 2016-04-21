defmodule What3WordsTest do
  use ExUnit.Case
  doctest What3Words

  test "words_to_position({word, not, found}) returns {:error, :coordinates_not_found}" do
    assert What3Words.words_to_position(
      {"word", "not", "found"}
    ) == {:error, :coordinates_not_found}
  end

  test "words_to_position({index, home, raft}) returns {:ok, {29.396521, -98.661698}}" do
    assert What3Words.words_to_position(
      {"index", "home", "raft"}
    ) == {:ok, {29.396521, -98.661698}}
  end

  test "position_to_words({123141.2, 12423523.1}) returns {:error, :words_not_found}" do
    assert What3Words.position_to_words(
      {123141.2, 12423523.1}
    ) == {:error, :words_not_found}
  end

  test "position_to_words({29.396521, -98.661698}) returns {:ok, {home, index, raft}}" do
    assert What3Words.position_to_words(
      {29.396521, -98.661698}
    ) == {:ok, {"index", "home", "raft"}}
  end

  test "languages() returns {:ok, [en, fr]}" do
    assert What3Words.languages == {:ok, ["en", "fr"]}
  end
end
