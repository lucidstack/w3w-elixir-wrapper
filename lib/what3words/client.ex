defmodule What3Words.Client do
  @moduledoc ~S"""
  Uses `HTTPoison.Base` to make calls to the w3w API.
  Uses `Poison` to decode the JSON response, and transforms
  the root keys into atoms.
  """
  use HTTPoison.Base

  @base_url "https://api.what3words.com"
  def process_url(url) do
    @base_url <> url
  end

  def process_response_body(body) do
    json = body |> Poison.decode!

    for {k, v} <- json, into: %{}, do: {String.to_atom(k), v}
  end
end
