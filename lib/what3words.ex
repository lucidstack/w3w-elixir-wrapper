defmodule What3Words do
  @moduledoc """
    What3Words is the main module to interact with the w3w API.
    It includes calls to the three current endpoints: `words_to_position/2`,
    `position_to_words/2` and `languages/2`.

    To use the What3Words API, be sure
  """

  @client Application.get_env(:what3words, :client, What3Words.Client)
  import What3Words.Extractor

  # Types
  #######
  @type lat :: float()
  @type lng :: float()
  @type w3w    :: {String.t, String.t, String.t}
  @type coords :: {lat, lng}

  @spec words_to_position(w3w, Keyword.t) :: coords
  @doc """
    Translates a tuple of 3 words into a `{lat, lng}` tuple.
    An optional `opts` keyword argument can be passed: the opts cited [in the w3w API documentation](http://developer.what3words.com/api) are supported, plus a `:raw` option is supported, for retrieving the whole response from the API.

    ## Examples
        iex> What3Words.words_to_position({"home", "index", "raft"})
        {:ok, {40.723008, -74.199598}}

        iex> What3Words.words_to_position({"home", "index", "raft"}, raw: true)
        {:ok, %{language: "en", position: [40.723008, -74.199598], type: "3 words", words: ["home", "index", "raft"]}}
  """
  def words_to_position(words, opts \\ []) do
    words
    |> make_path(opts)
    |> @client.get!
    |> extract(:coordinates, opts[:raw])
  end

  @spec position_to_words(coords, Keyword.t) :: w3w
  @doc """
    Translates a tuple `{lat, lng}` into a tuple of 3 words.
    An optional `opts` keyword argument can be passed: the opts cited [in the w3w API documentation](http://developer.what3words.com/api) are supported, plus a `:raw` option is supported, for retrieving the whole response from the API.

    ## Examples
        iex> What3Words.position_to_words({40.723008, -74.199598})
        {:ok, {"home", "index", "raft"}}

        iex> What3Words.position_to_words({40.723008, -74.199598}, raw: true)
        {:ok, %{language: "en", position: [40.723008, -74.199598], words: ["home", "index", "raft"]}}
  """
  def position_to_words(coords, opts \\ []) do
    coords
    |> make_path(opts)
    |> @client.get!
    |> extract(:words, opts[:raw])
  end

  @spec languages(Keyword.t) :: [String.t]
  @doc """
    Retrieves all available languages from the w3w API.
    An optional `opts` keyword argument can be passed: the opts cited [in the w3w API documentation](http://developer.what3words.com/api) are supported, plus a `:raw` option is supported, for retrieving the whole response from the API.

    ## Examples
        iex> What3Words.languages
        {:ok, ["en", "fr"]}

        iex> What3Words.languages(raw: true)
        {:ok, %{languages: [%{"code" => "en", "name_display" => "English"},
                            %{"code" => "fr", "name_display" => "French"}]
        }}
  """
  def languages(opts \\ []) do
    make_path(opts)
    |> @client.get!
    |> extract(:languages, opts[:raw])
  end

  @spec words_to_position!(w3w, Keyword.t) :: coords
  def words_to_position!(words, opts \\ []) do
    {:ok, result} = words_to_position(words, opts)
    result
  end

  @spec position_to_words!(coords, Keyword.t) :: w3w
  def position_to_words!(words, opts \\ []) do
    {:ok, result} = position_to_words(words, opts)
    result
  end

  @spec languages!(Keyword.t) :: [String.t]
  def languages!(opts \\ []) do
    {:ok, result} = languages(opts)
    result
  end

  # Private implementation
  ########################
  @api_token Application.get_env(:what3words, :key)

  defp make_path({w1, w2, w3}, opts) do
    [key: @api_token, string: "#{w1}.#{w2}.#{w3}"] |> do_make_path("w3w", opts)
  end

  defp make_path({lat, lng}, opts) do
    [key: @api_token, position: "#{lat}, #{lng}"]  |> do_make_path("position", opts)
  end

  defp make_path(opts) do
    [key: @api_token]  |> do_make_path("get-languages", opts)
  end

  defp do_make_path(query, path, opts) do
    query = query |> Keyword.merge(opts) |> URI.encode_query
    "/#{path}?#{query}"
  end
end
