defmodule What3Words.Extractor do
  @spec extract(%{}, :atom, boolean()) :: {:ok, any()} | {:error, any()}
  def extract(response, type, raw)

  def extract(%{body: %{error: _} = body}, _type, true), do: {:error, body}
  def extract(%{body: body},               _type, true), do: {:ok,    body}

  def extract(%{body: %{position: pos}},    :coordinates, _raw), do: {:ok, pos   |> List.to_tuple}
  def extract(%{body: %{words: words}},     :words,       _raw), do: {:ok, words |> List.to_tuple}
  def extract(%{body: %{languages: langs}}, :languages,   _raw), do: {:ok, langs |> Enum.map(&get_code/1)}

  def extract(response, type,  _raw), do: {:error, "#{type}_not_found" |> String.to_atom}

  # Private implementation
  ########################
  defp get_code(language), do: language["code"]
end
