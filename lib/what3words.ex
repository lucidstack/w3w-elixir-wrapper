defmodule What3Words do
  @moduledoc """
  What3Words is the main module to interact with the w3w API.
  It includes calls to the three current endpoints: `forward/2`,
  `reverse/2` and `languages/1`.

  To use the What3Words API, be sure to have your API key set up in your `config.exs`:

      config :what3words, key: "yourkey"
  """


  @client Application.get_env(:what3words, :client, What3Words.Client)
  alias What3Words.Extractor

  # Types
  #######
  @type lat :: float()
  @type lng :: float()
  @type w3w    :: {String.t, String.t, String.t}
  @type coords :: {lat, lng}


  @spec forward(w3w, Keyword.t) :: coords
  @doc ~S"""
  Translates a string or a tuple of 3 words into a `{lat, lng}` tuple.
  An optional `opts` keyword argument can be passed: the opts cited [in the w3w API documentation](http://developer.what3words.com/api)
  will be proxied; furthermore, a `:raw` option is supported, for retrieving the whole response from the API.

      iex> What3Words.forward("home.index.raft")
      {:ok, %{lat: 40.723008, lng: -74.199598}}

      iex> What3Words.forward({"home", "index", "raft"})
      {:ok, %{lat: 40.723008, lng: -74.199598}}

      iex> What3Words.forward({"home", "index", "raft"}, raw: true)
      {:ok, %{language: "en", geometry: %{"lat" => 40.723008, "lng" => -74.199598}, words: "home.index.raft"}}
  """
  def forward(words, opts \\ []) do
    words
    |> make_path(opts)
    |> @client.get!
    |> Extractor.extract(:coordinates, opts[:raw])
  end


  @spec reverse(coords, Keyword.t) :: w3w
  @doc ~S"""
  Translates a tuple `{lat, lng}` into a tuple of 3 words.
  An optional `opts` keyword argument can be passed: the opts cited [in the w3w API documentation](http://developer.what3words.com/api)
  are supported, plus a `:raw` option is supported, for retrieving the whole response from the API.

      iex> What3Words.reverse({40.723008, -74.199598})
      {:ok, "home.index.raft"}

      iex> What3Words.reverse({40.723008, -74.199598}, raw: true)
      {:ok, %{language: "en", geometry: %{"lat" => 40.723008, "lng" => -74.199598}, words: "home.index.raft"}}
  """
  def reverse(coords, opts \\ []) do
    coords
    |> make_path(opts)
    |> @client.get!
    |> Extractor.extract(:words, opts[:raw])
  end


  @spec languages(Keyword.t) :: [String.t]
  @doc ~S"""
  Retrieves all available languages from the w3w API.
  An optional `opts` keyword argument can be passed: the opts cited [in the w3w API documentation](http://developer.what3words.com/api)
  are supported, plus a `:raw` option is supported, for retrieving the whole response from the API.

      iex> What3Words.languages
      {:ok, ["en", "fr"]}

      iex> What3Words.languages(raw: true)
      {:ok, %{languages: [%{"code" => "en", "name_display" => "English"}, %{"code" => "fr", "name_display" => "French"}]}}
  """
  def languages(opts \\ []) do
    opts
    |> make_path
    |> @client.get!
    |> Extractor.extract(:languages, opts[:raw])
  end

  @doc ~S"""
  Same as `forward/2`, but returns the naked values (instead of
  `{:ok, value}`). Raises a `MatchError` if words are not found.
  """
  @spec forward!(w3w, Keyword.t) :: coords
  def forward!(words, opts \\ []) do
    {:ok, result} = forward(words, opts)
    result
  end

  @doc ~S"""
  Same as `reverse/2`, but returns the naked values (instead of
  `{:ok, value}`). Raises a `MatchError` if words are not found.
  """
  @spec reverse!(coords, Keyword.t) :: w3w
  def reverse!(words, opts \\ []) do
    {:ok, result} = reverse(words, opts)
    result
  end

  @doc ~S"""
  Same as `languages/1`, but returns the naked values (instead of
  `{:ok, value}`). Raises a `MatchError` if words are not found.
  """
  @spec languages!(Keyword.t) :: [String.t]
  def languages!(opts \\ []) do
    {:ok, result} = languages(opts)
    result
  end

  # Private implementation
  ########################
  @api_token Application.get_env(:what3words, :key)

  defp make_path({w1, w2, w3}, opts) do
    [key: @api_token, addr: "#{w1}.#{w2}.#{w3}"] |> do_make_path("forward", opts)
  end

  defp make_path(words, opts) when is_binary(words) do
    [key: @api_token, addr: words] |> do_make_path("forward", opts)
  end

  defp make_path({lat, lng}, opts) do
    [key: @api_token, coords: "#{lat},#{lng}"] |> do_make_path("reverse", opts)
  end

  defp make_path(opts) do
    [key: @api_token]  |> do_make_path("get-languages", opts)
  end

  defp do_make_path(query, path, opts) do
    query = query |> Keyword.merge(opts) |> URI.encode_query
    "/#{path}?#{query}"
  end
end
