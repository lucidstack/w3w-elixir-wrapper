defmodule What3Words.Extractor do
  @moduledoc ~S"""
  A pure module to extract words, coordinates, and languages from
  the w3w API response.
  """

  @type extracted_type :: :coordinates | :words | :languages

  @spec extract(%{}, extracted_type, boolean()) :: {:ok, any()} | {:error, any()}
  def extract(response, type, raw)

  def extract(%{body: %{error: _} = body}, _type,         true), do: {:error, body}
  def extract(%{body: body},               _type,         true), do: {:ok,    body}

  def extract(%{body: %{geometry: pos}},    :coordinates, _raw), do: {:ok, pos   |> extract_position}
  def extract(%{body: %{words: words}},     :words,       _raw), do: {:ok, words}
  def extract(%{body: %{languages: langs}}, :languages,   _raw), do: {:ok, langs |> Enum.map(&get_code/1)}

  def extract(_response, type,  _raw), do: {:error, "#{type}_not_found" |> String.to_atom}

  # Private implementation
  ########################
  defp get_code(language) do
    language["code"]
  end

  defp extract_position(%{"lat" => lat, "lng" => lng}) do
    %{lat: lat, lng: lng}
  end
end
