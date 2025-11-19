defmodule Harmony.Transpose do
  @moduledoc """
  Functions for transposing notes and intervals.

  Transposition moves a note up or down by a specified interval, maintaining proper
  enharmonic spelling. This module provides both direct transposition and functional
  composition patterns.

  ## Examples

      # Transpose a note by an interval
      iex> Harmony.Transpose.transpose("C4", "5P")
      "G4"

      # Create a reusable transposer
      iex> up_fifth = Harmony.Transpose.transpose_by("5P")
      iex> up_fifth.("C")
      "G"

  See the [Transposition guide](docs/transpose.md) for detailed documentation.
  """

  alias Harmony.Interval
  alias Harmony.Note

  def transpose(name, ivl) when is_binary(name) or is_binary(ivl),
    do: transpose(Note.get(name), Interval.get(ivl))

  def transpose(%Note{empty: true}, _), do: ""
  def transpose(_, %Interval{empty: true}), do: ""

  def transpose(%Note{coord: [n0]}, %Interval{coord: [i0 | _]}),
    do: Note.from_coord([n0 + i0]).name

  def transpose(%Note{coord: [n0, n1]}, %Interval{coord: [i0, i1 | _]}),
    do: Note.from_coord([n0 + i0, n1 + i1]).name

  def transpose_from(note) when is_binary(note), do: transpose_from(Note.get(note))
  def transpose_from(%Note{} = n), do: &transpose(n, &1)

  def transpose_by(ivl) when is_binary(ivl), do: transpose_by(Interval.get(ivl))
  def transpose_by(%Interval{} = i), do: &transpose(&1, i)

  def transpose_fifths(_, nil), do: nil

  def transpose_fifths(name, f) when is_binary(name) do
    case Note.get(name) do
      %{empty: true} -> transpose_fifths(Interval.get(name), f)
      n -> transpose_fifths(n, f)
    end
  end

  def transpose_fifths(%Note{empty: true}, _), do: ""

  def transpose_fifths(%Note{coord: [n_fifths]}, fifths),
    do: Note.from_coord([n_fifths + fifths]).pc

  def transpose_fifths(%Note{coord: [n_fifths, n_octs]}, fifths),
    do: Note.from_coord([n_fifths + fifths, n_octs]).name

  def transpose_fifths(%Interval{empty: true}, _), do: ""

  def transpose_fifths(%Interval{coord: [n_fifths, n_octs]}, fifths),
    do: Interval.from_coord([n_fifths + fifths, n_octs]).name

  def transpose_fifths(%Interval{coord: [n_fifths, n_octs, dir]}, fifths),
    do: Interval.from_coord([n_fifths + fifths, n_octs, dir]).name

  def transpose_fifths(%Interval{}), do: ""
end
