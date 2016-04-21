defmodule What3Words.Client do
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
