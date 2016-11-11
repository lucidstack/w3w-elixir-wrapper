defmodule What3Words do
  @moduledoc """
  What3Words is the main module to interact with the w3w API.
  It includes calls to all current endpoints: `forward/2`,
  `reverse/2`, `languages/1`, and `autosuggest/3` (`standardblend` and `grid` coming soon!).

  To use the What3Words API, be sure to have your API key set up in your `config.exs`:

      config :what3words, key: "yourkey"
  """


  @client Application.get_env(:what3words, :client, What3Words.Client)
  alias What3Words.Extractor

  # Types
  #######
  @type lat :: float()
  @type lng :: float()
  @type w3w    :: {String.t, String.t, String.t} | String.t
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


  @spec autosuggest(String.t, String.t, Keyword.t) :: [%{}]
  @doc ~S"""
  Retrieves all suggestions for the supplied 3 word address string, given at least 2 and the first letter of the third. In addition,
  providing a language is mandatory for the `autosuggest` endpoint.
  An optional `opts` keyword argument can be passed: the opts cited [in the w3w API documentation](http://developer.what3words.com/api)
  are supported, plus a `:raw` option is supported, for retrieving the whole response from the API.

      iex> What3Words.autosuggest("home.index.r", "en")
      {:ok, [
        %What3Words.Suggestion{
          distance: 1,
          rank: 1,
          words: "no.options.request",
          score: 1,
          place: "King's College, Cambridge",
          country: "gb",
          geometry: %{
            lng: 1.000000,
            lat: 1.000000
          }
        }
      ]}

  The `clip` and `focus` options work a little bit differently, just to spare you from creating the wanted string yourself.
  Here's examples for both:

      #
      # radius in km around lat and lng
      iex> {lat, lng, km} = {1, 1, 10}
      iex> opts = %{clip: %{radius: {lat, lng, km}}}
      iex> What3Words.autosuggest("home.index.r", "en", opts)
      {:ok, [
        %What3Words.Suggestion{
          distance: 1,
          rank: 1,
          words: "clip.radius.request",
          score: 1,
          place: "King's College, Cambridge",
          country: "gb",
          geometry: %{
            lng: 1.000000,
            lat: 1.000000
          }
        }
      ]}

      #
      # bounding box between north east and south west points
      iex> {nelat, nelng, swlat, swlng} = {1, 1, -1, -1}
      iex> opts = %{clip: %{bbox: {nelat, nelng, swlat, swlng}}}
      iex> What3Words.autosuggest("home.index.r", "en", opts)
      {:ok, [
        %What3Words.Suggestion{
          distance: 1,
          rank: 1,
          words: "clip.bbox.request",
          score: 1,
          place: "King's College, Cambridge",
          country: "gb",
          geometry: %{
            lng: 1.000000,
            lat: 1.000000
          }
        }
      ]}

      #
      # clip around focus point by km
      iex> {focus_lat, focus_lng, km} = {1, 1, 10}
      iex> opts = %{clip: %{focus: km}, focus: {focus_lat, focus_lng}}
      iex> What3Words.autosuggest("home.index.r", "en", opts)
      {:ok, [
        %What3Words.Suggestion{
          distance: 1,
          rank: 1,
          words: "clip.focus.request",
          score: 1,
          place: "King's College, Cambridge",
          country: "gb",
          geometry: %{
            lng: 1.000000,
            lat: 1.000000
          }
        }
      ]}

      #
      # focus around lat and lng for better results
      iex> {focus_lat, focus_lng} = {1, 1}
      iex> opts = %{focus: {focus_lat, focus_lng}}
      iex> What3Words.autosuggest("home.index.r", "en", opts)
      {:ok, [
        %What3Words.Suggestion{
          distance: 1,
          rank: 1,
          words: "focus.option.request",
          score: 1,
          place: "King's College, Cambridge",
          country: "gb",
          geometry: %{
            lng: 1.000000,
            lat: 1.000000
          }
        }
      ]}

    If you don't like fiddling with those options, good old strings are still supported for the
    `clip` and `focus` options. If binary strings are detected, the transformations will just be
    skipped.
  """
  def autosuggest(words, language, opts \\ []) do
    words
    |> make_path(language, opts)
    |> @client.get!
    |> Extractor.extract(:autosuggest, opts[:raw])
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


  #
  # Private implementation
  ########################
  @api_token Application.get_env(:what3words, :key)

  # Paths for /forward
  ########################
  defp make_path({w1, w2, w3}, opts) do
    [key: @api_token, addr: "#{w1}.#{w2}.#{w3}"] |> do_make_path("forward", opts)
  end

  defp make_path(words, opts) when is_binary(words) do
    [key: @api_token, addr: words] |> do_make_path("forward", opts)
  end


  # Paths for /reverse
  ########################
  defp make_path({lat, lng}, opts) do
    [key: @api_token, coords: "#{lat},#{lng}"] |> do_make_path("reverse", opts)
  end


  # Paths for /languages
  ########################
  defp make_path(opts) do
    [key: @api_token]  |> do_make_path("languages", opts)
  end


  # Paths for /autosuggest
  ########################
  defp make_path(words, language, opts) do
    opts = normalize_autosuggest_opts(opts)
    [key: @api_token, addr: words, lang: language] |> do_make_path("autosuggest", opts)
  end

  defp normalize_autosuggest_opts(%{clip: clip} = opts) when not is_binary(clip) do
    clip = case clip do
      %{bbox: {nelat, nelng, swlat, swlng}} -> "bbox(#{nelat},#{nelng},#{swlat},#{swlng})"
      %{radius: {lat, lng, km}}             -> "radius(#{lat},#{lng},#{km})"
      %{focus: km}                          -> "focus(#{km})"
      false                                 -> "none"
    end

    opts
    |> Map.put(:clip, clip)
    |> normalize_autosuggest_opts()
  end

  defp normalize_autosuggest_opts(%{focus: {lat, lng}} = opts) do
    opts
    |> Map.put(:focus, "#{lat},#{lng}")
    |> normalize_autosuggest_opts()
  end

  # Ultimately return the opts as a kw collection
  defp normalize_autosuggest_opts(opts) do
    opts |> Keyword.new()
  end

  defp do_make_path(query, path, opts) do
    query = query |> Keyword.merge(opts) |> URI.encode_query
    "/#{path}?#{query}"
  end
end
