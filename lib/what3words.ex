defmodule What3Words do
  @client Application.get_env(:what3words, :client)
  import What3Words.Extractor

  # Types
  #######
  @type w3w    :: {String.t, String.t, String.t}
  @type coords :: {float(), float()}

  @spec words_to_position(w3w, Keyword.t) :: coords
  def words_to_position(words, opts \\ []) do
    words
    |> make_path(opts)
    |> @client.get!
    |> extract(:coordinates, opts[:raw])
  end

  @spec position_to_words(coords, Keyword.t) :: w3w
  def position_to_words(coords, opts \\ []) do
    coords
    |> make_path(opts)
    |> @client.get!
    |> extract(:words, opts[:raw])
  end

  @spec languages(Keyword.t) :: [String.t]
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

  @spec languages(Keyword.t) :: [String.t]
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
