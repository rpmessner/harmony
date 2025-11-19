#!/usr/bin/env elixir

# Benchmark to compare macro-generated approach vs runtime lookup approach

defmodule RuntimeNote do
  @moduledoc """
  Alternative implementation using runtime calculation instead of compile-time generation.
  """

  defstruct(
    acc: "",
    alt: 0,
    chroma: 0,
    coord: [0, 0],
    empty: true,
    freq: 0,
    height: 0,
    letter: "",
    midi: 0,
    name: "",
    note: "",
    oct: 0,
    pc: "",
    simple: "",
    step: 0
  )

  @letters ~w(A B C D E F G)
  @semi [0, 2, 4, 5, 7, 9, 11]
  @noteregex ~r/^([a-gA-G]?)(\#{1,}|b{1,}|x{1,}|)(-?\d*)\s*(.*)$/

  def get(""), do: %__MODULE__{}

  def get(name) when is_binary(name) do
    case tokenize(name) do
      ["", "", "", _] -> %__MODULE__{}
      [letter, acc_str, oct_str, ""] ->
        parse_note(letter, acc_str, oct_str)
      _ -> %__MODULE__{}
    end
  end

  def get(_), do: %__MODULE__{}

  defp parse_note(letter, acc_str, oct_str) do
    letter_char = letter |> String.to_charlist() |> List.first()
    step = rem(letter_char + 3, 7)
    alt = to_alt(acc_str)

    octave = case oct_str do
      "" -> nil
      oct -> String.to_integer(oct)
    end

    pc_acc = to_pc_acc(alt)
    pc = letter <> pc_acc
    name = letter <> pc_acc <> (oct_str || "")
    semi_step = Enum.at(@semi, step)
    chroma = rem(semi_step + alt + 120, 12)

    height = if octave do
      semi_step + alt + 12 * (octave + 1)
    else
      rem(semi_step + alt, 12) - 12 * 99
    end

    midi = if height >= 0 && height <= 127, do: height
    freq = if octave, do: Float.pow(2.0, (height - 69) / 12) * 440
    simple = to_note_name(midi || chroma, sharp: alt > 0, pitch_class: is_nil(midi))

    %__MODULE__{
      acc: acc_str,
      alt: alt,
      chroma: chroma,
      coord: encode_pitch(step, alt, octave),
      empty: false,
      freq: freq,
      height: height,
      letter: letter,
      midi: midi,
      name: name,
      oct: octave,
      pc: pc,
      simple: simple,
      step: step
    }
  end

  defp tokenize(str) when is_binary(str) do
    [[_, m1, m2, m3, m4]] = Regex.scan(@noteregex, str)
    [String.upcase(m1), String.replace(m2, ~r/x/, "##"), m3, m4]
  end

  defp to_alt(""), do: 0
  defp to_alt("#"), do: 1
  defp to_alt("##"), do: 2
  defp to_alt("###"), do: 3
  defp to_alt("b"), do: -1
  defp to_alt("bb"), do: -2
  defp to_alt("bbb"), do: -3
  defp to_alt(_), do: 0

  defp to_pc_acc(0), do: ""
  defp to_pc_acc(n) when n > 0, do: String.duplicate("#", n)
  defp to_pc_acc(n) when n < 0, do: String.duplicate("b", abs(n))

  defp encode_pitch(step, alt, nil), do: [step * 7 + alt * 12, nil]
  defp encode_pitch(step, alt, oct), do: [step * 7 + alt * 12, oct]

  defp to_note_name(midi, opts) do
    # Simplified version
    notes = if Keyword.get(opts, :sharp),
      do: ~w(C C# D D# E F F# G G# A A# B),
      else: ~w(C Db D Eb E F Gb G Ab A Bb B)

    chroma = rem(midi, 12)
    note = Enum.at(notes, chroma)

    if Keyword.get(opts, :pitch_class) do
      note
    else
      octave = div(midi, 12) - 1
      "#{note}#{octave}"
    end
  end
end

# Benchmark script
IO.puts("\n=== Macro-Generated vs Runtime Calculation Benchmark ===\n")

# Compile the main project first
Mix.install([])
Code.require_file("lib/harmony.ex", __DIR__)
Code.require_file("lib/harmony/util.ex", __DIR__)
Code.require_file("lib/harmony/pitch.ex", __DIR__)
Code.require_file("lib/harmony/note.ex", __DIR__)

test_notes = [
  "C4", "D#4", "Eb5", "F#3", "Gb6", "A4", "B3",
  "C", "D#", "Eb", "F#", "Gb", "A", "B",
  "C0", "C1", "C2", "C3", "C5", "C6", "C7", "C8"
]

iterations = 100_000

# Warmup
Enum.each(1..1000, fn _ ->
  Enum.each(test_notes, &Harmony.Note.get/1)
  Enum.each(test_notes, &RuntimeNote.get/1)
end)

# Benchmark macro-generated approach
{macro_time, _} = :timer.tc(fn ->
  Enum.each(1..iterations, fn _ ->
    Enum.each(test_notes, &Harmony.Note.get/1)
  end)
end)

# Benchmark runtime approach
{runtime_time, _} = :timer.tc(fn ->
  Enum.each(1..iterations, fn _ ->
    Enum.each(test_notes, &RuntimeNote.get/1)
  end)
end)

total_calls = iterations * length(test_notes)

IO.puts("Total function calls: #{total_calls}")
IO.puts("\nMacro-generated (compile-time):")
IO.puts("  Total time: #{macro_time / 1_000_000} seconds")
IO.puts("  Per call: #{macro_time / total_calls} μs")

IO.puts("\nRuntime calculation:")
IO.puts("  Total time: #{runtime_time / 1_000_000} seconds")
IO.puts("  Per call: #{runtime_time / total_calls} μs")

speedup = runtime_time / macro_time
IO.puts("\nSpeedup: #{Float.round(speedup, 2)}x faster with macros")

# Memory comparison
macro_result = Harmony.Note.get("C4")
runtime_result = RuntimeNote.get("C4")

IO.puts("\nResult comparison:")
IO.puts("Macro MIDI: #{inspect(macro_result.midi)}")
IO.puts("Runtime MIDI: #{inspect(runtime_result.midi)}")
IO.puts("Macro Freq: #{inspect(macro_result.freq)}")
IO.puts("Runtime Freq: #{inspect(runtime_result.freq)}")

# Compile-time costs
IO.puts("\n=== Compile-Time Analysis ===")
IO.puts("\nCalculating generated function count...")

# Notes: 7 letters × 9 accidentals × 13 octaves = 819 note combinations
# Each generates ~4 function clauses (get/1 variations)
note_combinations = 7 * 9 * 13
note_clauses_per_combo = 4
estimated_note_clauses = note_combinations * note_clauses_per_combo

IO.puts("Estimated Note.get/1 clauses: ~#{estimated_note_clauses}")

# Intervals: 12 qualities × 41 numbers = 492 combinations
# Each generates 2 clauses
interval_combinations = 12 * 41
interval_clauses_per_combo = 2
estimated_interval_clauses = interval_combinations * interval_clauses_per_combo

IO.puts("Estimated Interval.get/1 clauses: ~#{estimated_interval_clauses}")
IO.puts("\nTotal estimated function clauses: ~#{estimated_note_clauses + estimated_interval_clauses}")
