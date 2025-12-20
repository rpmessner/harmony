defmodule Harmony.Voicing do
  @moduledoc """
  Chord voicing generation and dictionaries.

  This module provides voicing patterns for common chord types, inspired by
  jazz piano voicing conventions. Voicings are defined as interval patterns
  from the chord root.

  ## Voicing Dictionaries

  - `:lefthand` - Jazz left-hand piano voicings (shells + tensions)
  - `:triads` - Simple triad voicings in different inversions
  - `:guidetones` - Minimal two-note voicings (3rd and 7th)

  ## Examples

      iex> Harmony.Voicing.voice("Cm7")
      ["Eb", "G", "Bb", "D"]

      iex> Harmony.Voicing.voice("G7", dictionary: :guidetones)
      ["B", "F"]

      iex> Harmony.Voicing.intervals_for("m7", :lefthand)
      ["3m", "5P", "7m", "9M"]
  """

  alias Harmony.Chord
  alias Harmony.Transpose

  # Left-hand jazz piano voicings (shells + tensions)
  # Format: chord type => list of voicing options (each is a space-separated interval string)
  @lefthand %{
    "m7" => ["3m 5P 7m 9M", "7m 9M 10m 12P"],
    "7" => ["3M 6M 7m 9M", "7m 9M 10M 13M"],
    "^7" => ["3M 5P 7M 9M", "7M 9M 10M 12P"],
    "M7" => ["3M 5P 7M 9M", "7M 9M 10M 12P"],
    "maj7" => ["3M 5P 7M 9M", "7M 9M 10M 12P"],
    "69" => ["3M 5P 6M 9M"],
    "6" => ["3M 5P 6M"],
    "m7b5" => ["3m 5d 7m 8P", "7m 8P 10m 12d"],
    "7b9" => ["3M 6m 7m 9m", "7m 9m 10M 13m"],
    "7b13" => ["3M 6m 7m 9m", "7m 9m 10M 13m"],
    "o7" => ["1P 3m 5d 6M", "5d 6M 8P 10m"],
    "dim7" => ["1P 3m 5d 6M", "5d 6M 8P 10m"],
    "7#11" => ["7m 9M 11A 13M"],
    "7#9" => ["3M 7m 9A"],
    "mM7" => ["3m 5P 7M 9M", "7M 9M 10m 12P"],
    "m6" => ["3m 5P 6M 9M", "6M 9M 10m 12P"]
  }

  # Simple triad voicings (root position and inversions)
  @triads %{
    "" => ["1P 3M 5P", "3M 5P 8P", "5P 8P 10M"],
    "M" => ["1P 3M 5P", "3M 5P 8P", "5P 8P 10M"],
    "maj" => ["1P 3M 5P", "3M 5P 8P", "5P 8P 10M"],
    "m" => ["1P 3m 5P", "3m 5P 8P", "5P 8P 10m"],
    "min" => ["1P 3m 5P", "3m 5P 8P", "5P 8P 10m"],
    "o" => ["1P 3m 5d", "3m 5d 8P", "5d 8P 10m"],
    "dim" => ["1P 3m 5d", "3m 5d 8P", "5d 8P 10m"],
    "aug" => ["1P 3M 5A", "3M 5A 8P", "5A 8P 10M"],
    "+" => ["1P 3M 5A", "3M 5A 8P", "5A 8P 10M"]
  }

  # Guide tone voicings (minimal 3rd and 7th)
  @guidetones %{
    "m7" => ["3m 7m", "7m 10m"],
    "7" => ["3M 7m", "7m 10M"],
    "^7" => ["3M 7M", "7M 10M"],
    "M7" => ["3M 7M", "7M 10M"],
    "maj7" => ["3M 7M", "7M 10M"],
    "m7b5" => ["3m 7m", "7m 10m"],
    "o7" => ["3m 6M", "6M 10m"],
    "dim7" => ["3m 6M", "6M 10m"]
  }

  @dictionaries %{
    lefthand: @lefthand,
    triads: @triads,
    guidetones: @guidetones
  }

  @doc """
  Get a voicing for a chord symbol.

  Returns a list of note names representing the voiced chord.
  Uses the first available voicing option from the dictionary.

  ## Options

  - `:dictionary` - Which voicing dictionary to use (default: `:lefthand`)
  - `:inversion` - Which inversion to use, 0-indexed (default: 0)

  ## Examples

      iex> Harmony.Voicing.voice("Cm7")
      ["Eb", "G", "Bb", "D"]

      iex> Harmony.Voicing.voice("G7", dictionary: :guidetones)
      ["B", "F"]

      iex> Harmony.Voicing.voice("F", dictionary: :triads)
      ["F", "A", "C"]

      iex> Harmony.Voicing.voice("Am", dictionary: :triads, inversion: 1)
      ["C", "E", "A"]
  """
  @spec voice(String.t(), keyword()) :: list(String.t()) | nil
  def voice(chord_symbol, opts \\ []) do
    dictionary_name = Keyword.get(opts, :dictionary, :lefthand)
    inversion = Keyword.get(opts, :inversion, 0)

    chord = Chord.get(chord_symbol)

    if chord.empty do
      nil
    else
      # Try to find voicing intervals using chord aliases
      intervals_str = find_voicing_for_chord(chord, dictionary_name, inversion)

      if is_binary(intervals_str) do
        intervals = String.split(intervals_str, " ")

        Enum.map(intervals, fn interval ->
          Transpose.transpose(chord.tonic, interval)
        end)
      else
        nil
      end
    end
  end

  @doc """
  Get the interval pattern for a chord type from a dictionary.

  ## Examples

      iex> Harmony.Voicing.intervals_for("m7", :lefthand)
      "3m 5P 7m 9M"

      iex> Harmony.Voicing.intervals_for("M", :triads)
      "1P 3M 5P"
  """
  @spec intervals_for(String.t(), atom()) :: String.t() | nil
  def intervals_for(chord_type, dictionary_name) do
    get_voicing_intervals(chord_type, dictionary_name, 0)
  end

  @doc """
  List available voicing dictionaries.

  ## Examples

      iex> Harmony.Voicing.dictionaries()
      [:lefthand, :triads, :guidetones]
  """
  @spec dictionaries() :: list(atom())
  def dictionaries do
    Map.keys(@dictionaries)
  end

  @doc """
  Get all chord types available in a dictionary.

  ## Examples

      iex> "m7" in Harmony.Voicing.chord_types(:lefthand)
      true
  """
  @spec chord_types(atom()) :: list(String.t())
  def chord_types(dictionary_name) do
    case Map.get(@dictionaries, dictionary_name) do
      nil -> []
      dict -> Map.keys(dict)
    end
  end

  # Private helpers

  # Find voicing intervals for a chord by trying its aliases
  defp find_voicing_for_chord(chord, dictionary_name, inversion) do
    dictionary = Map.get(@dictionaries, dictionary_name, %{})

    # Build a list of type identifiers to try
    types_to_try = [chord.type | chord.aliases] ++ [normalize_chord_type(chord.type)]

    Enum.find_value(types_to_try, fn type ->
      get_voicing_from_dict(dictionary, type, inversion)
    end)
  end

  defp get_voicing_from_dict(dictionary, chord_type, inversion) do
    case Map.get(dictionary, chord_type) do
      nil -> nil
      voicings when is_list(voicings) -> Enum.at(voicings, inversion, List.first(voicings))
      voicing when is_binary(voicing) -> voicing
    end
  end

  defp get_voicing_intervals(chord_type, dictionary_name, inversion) do
    dictionary = Map.get(@dictionaries, dictionary_name, %{})

    # Try exact match first, then normalized forms
    voicings =
      Map.get(dictionary, chord_type) ||
        Map.get(dictionary, normalize_chord_type(chord_type))

    case voicings do
      nil -> nil
      voicings when is_list(voicings) -> Enum.at(voicings, inversion, List.first(voicings))
      voicing when is_binary(voicing) -> voicing
    end
  end

  # Normalize chord type aliases
  defp normalize_chord_type("minor" <> rest), do: "m" <> rest
  defp normalize_chord_type("major" <> rest), do: "M" <> rest
  defp normalize_chord_type(type), do: type
end
