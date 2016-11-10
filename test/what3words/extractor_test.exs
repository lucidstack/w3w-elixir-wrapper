defmodule What3WordsExtractorTest do
  import What3Words.Extractor
  use ExUnit.Case, async: true

  @test_response %{body: %{test: "this is"}, status_code: 200}
  test "extract(response, any, true) returns {:ok, response.body}" do
    assert extract(@test_response, :any, true) == {:ok, @test_response.body}
  end

  @test_response %{body: %{error: "this is"}, status_code: 200}
  test "extract(response_with_error, any, true) returns {:error, response.body}" do
    assert extract(@test_response, :any, true) == {:error, @test_response.body}
  end

  @test_response %{body: %{geometry: %{"lat" => 1.2, "lng" => 3.4}}, status_code: 200}
  test "extract(response, :coordinates, false) returns {:ok, coords}" do
    assert extract(@test_response, :coordinates, false) == {:ok, %{lat: 1.2, lng: 3.4}}
  end

  @test_response %{body: %{words: "home.index.raft"}, status_code: 200}
  test "extract(response, :words, false) returns {:ok, words}" do
    assert extract(@test_response, :words, false) == {:ok, "home.index.raft"}
  end

  @languages [%{"code" => "en", "name" => "English"}, %{"code" => "fr", "name" => "French"}]
  @test_response %{body: %{languages: @languages}, status_code: 200}
  test "extract(response, :languages, false) returns {:ok, languages}" do
    assert extract(@test_response, :languages, false) == {:ok, ["en", "fr"]}
  end

  @test_response %{body: %{error: "this is"}, status_code: 200}
  test "extract(response_with_error, type, true) returns {:error, :type_not_found}" do
    assert extract(@test_response, :words, false) == {:error, :words_not_found}
  end
end
