defmodule Harmony.IntervalTest do
  use ExUnit.Case

  alias Harmony.Interval
  alias Harmony.RomanNumeral

  test "get" do
    assert %Interval{
             alt: 0,
             chroma: 5,
             coord: [-1, 1],
             dir: 1,
             empty: false,
             name: "4P",
             num: 4,
             oct: 0,
             q: "P",
             semitones: 5,
             simple: 4,
             step: 3,
             type: "perfectable"
           } = Interval.get("P4")
  end

  test "shorthand properties" do
    assert "5d" = Interval.name("d5")
    assert 5 = Interval.num("d5")
    assert "d" = Interval.quality("d5")
    assert 6 = Interval.semitones("d5")
  end

  test "distance" do
    assert "5P" = Interval.distance("C4", "G4")
  end

  test "names" do
    assert ~w(1P 2M 3M 4P 5P 6m 7m) = Interval.names()
  end

  test "simplify intervals" do
    assert ~w(1P 2M 3M 4P 5P 6M 7M) = ~w(1P 2M 3M 4P 5P 6M 7M) |> Enum.map(&Interval.simplify(&1))

    assert ~w(8P 2M 3M 4P 5P 6M 7M) =
             ~w(8P 9M 10M 11P 12P 13M 14M) |> Enum.map(&Interval.simplify/1)

    assert ~w(1d 1P 1A 8d 8P 8A 1d 1P 1A) =
             ~w(1d 1P 1A 8d 8P 8A 15d 15P 15A) |> Enum.map(&Interval.simplify/1)

    assert ~w(-1P -2M -3M -4P -5P -6M -7M) =
             ~w(-1P -2M -3M -4P -5P -6M -7M) |> Enum.map(&Interval.simplify/1)

    assert ~w(-8P -2M -3M -4P -5P -6M -7M) =
             ~w(-8P -9M -10M -11P -12P -13M -14M) |> Enum.map(&Interval.simplify/1)
  end

  test "invert intervals" do
    assert ~w(1P 7m 6m 5P 4P 3m 2m) = ~w(1P 2M 3M 4P 5P 6M 7M) |> Enum.map(&Interval.invert(&1))

    assert ~w(1A 7M 6M 5A 4A 3M 2M) = ~w(1d 2m 3m 4d 5d 6m 7m) |> Enum.map(&Interval.invert(&1))

    assert ~w(1d 7d 6d 5d 4d 3d 2d) = ~w(1A 2A 3A 4A 5A 6A 7A) |> Enum.map(&Interval.invert(&1))

    assert ~w(-1P -7m -6m -5P -4P -3m -2m) =
             ~w(-1P -2M -3M -4P -5P -6M -7M) |> Enum.map(&Interval.invert/1)

    assert ~w(8P 14m 13m 12P 11P 10m 9m) =
             ~w(8P 9M 10M 11P 12P 13M 14M) |> Enum.map(&Interval.invert/1)
  end

  test "from_semitones" do
    assert ~w(1P 2m 2M 3m 3M 4P 5d 5P 6m 6M 7m 7M) =
             Enum.to_list(0..11) |> Enum.map(&Interval.from_semitones/1)

    assert ~w(8P 9m 9M 10m 10M 11P 12d 12P 13m 13M 14m 14M) =
             Enum.to_list(12..23) |> Enum.map(&Interval.from_semitones/1)

    assert ~w(1P -2m -2M -3m -3M -4P -5d -5P -6m -6M -7m -7M) =
             Enum.to_list(0..-11//-1) |> Enum.map(&Interval.from_semitones/1)

    assert ~w(-8P -9m -9M -10m -10M -11P -12d -12P -13m -13M -14m -14M) =
             Enum.to_list(-12..-23//-1) |> Enum.map(&Interval.from_semitones/1)
  end

  test "add" do
    assert "7m" = Interval.add("3m", "5P")
    assert ~w(5P 6M 7M 8P 9M 10m 11P) = Interval.names() |> Enum.map(&Interval.add("5P", &1))
    assert ~w(5P 6M 7M 8P 9M 10m 11P) = Interval.names() |> Enum.map(&Interval.add_to("5P").(&1))
  end

  test "Can convert from romans" do
    assert "1P" = Interval.get(RomanNumeral.get("I")).name
    assert "3m" = Interval.get(RomanNumeral.get("bIIImaj4")).name
    assert "4A" = Interval.get(RomanNumeral.get("#IV7")).name
  end

  test "subtract" do
    assert "3m" = Interval.subtract("5P", "3M")
    assert "-3m" = Interval.subtract("3M", "5P")

    assert ~w(5P 4P 3m 2M 1P -2m -3m) = Interval.names() |> Enum.map(&Interval.subtract("5P", &1))
  end
end
