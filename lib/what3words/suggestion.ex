defmodule What3Words.Suggestion do
  @moduledoc ~S"""
  Holds the struct for suggestions coming from the
  autosuggest endpoint
  """
  defstruct [:distance, :rank, :words, :score, :place, :country, :geometry]
end
