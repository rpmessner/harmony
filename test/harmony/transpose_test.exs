defmodule Harmony.TransposeTest do
  use ExUnit.Case

  alias Harmony.Transpose

  test "transpose_fifths" do
    # interval
    assert "8P" = Transpose.transpose_fifths("4P", 1)
    assert ~w(1P 5P 9M 13M 17M) = 0..4 |> Enum.map(&Transpose.transpose_fifths("1P", &1))
    assert ~w(1P -5P -9M -13M -17M) = 0..-4 |> Enum.map(&Transpose.transpose_fifths("1P", &1))

    # note
    assert "E6" = Transpose.transpose_fifths("G4", 3)
    assert "E" = Transpose.transpose_fifths("G", 3)
    assert ~w(C2 G2 D3 A3 E4 B4) = 0..5 |> Enum.map(&Transpose.transpose_fifths("C2", &1))
    assert ~w(F# C# G# D# A# E# B#) = 0..6 |> Enum.map(&Transpose.transpose_fifths("F#", &1))
    assert ~w(Bb Eb Ab Db Gb Cb Fb) = 0..-6 |> Enum.map(&Transpose.transpose_fifths("Bb", &1))
  end

  test "transpose" do
    assert "C#5" = Transpose.transpose("A4", "3M")
  end

  test "invalid notes and intervals" do
    assert "" = Transpose.transpose("M3", "blah")
    assert "" = Transpose.transpose("blah", "C2")
    assert "" = Transpose.transpose("", "")
  end

  test "transpose pitch classes by intervals" do
    assert ~w(Bb D F A) = ~w(P1 M3 P5 M7) |> Enum.map(&Transpose.transpose("Bb", &1))
  end

  test "transpose notes by intervals" do
    assert ~w(Bb2 D3 F3 A3) = ~w(P1 M3 P5 M7) |> Enum.map(&Transpose.transpose("Bb2", &1))
  end

  test "tranpose note by descending intervas" do
    assert ~w(Bb Gb Eb Cb) = ~w(P-1 M-3 P-5 M-7) |> Enum.map(&Transpose.transpose("Bb", &1))
  end

  test "transpose by interval" do
    assert ~w(E2 F#3 A4 B5) = ~w(c2 d3 f4 g5) |> Enum.map(&Transpose.transpose(&1, "3M"))
  end

  test "transpose by descending intervals" do
    assert ~w(Bb1 C3 Eb4 F5) = ~w(c2 d3 f4 g5) |> Enum.map(&Transpose.transpose(&1, "-2M"))
  end

  test "transpose edge cases" do
    from_c2 = fn ivls ->
      Enum.map(ivls, &Transpose.transpose("C2", &1))
    end

    assert ~w(Cb2 C2 C#2) = ~w(1d 1P 1A) |> from_c2.()
    assert ~w(C#2 C2 Cb2) = ~w(-1d -1P -1A) |> from_c2.()
    assert ~w(Dbb2 Db2 D2 D#2) = ~w(2d 2m 2M 2A) |> from_c2.()
    assert ~w(B#1 B1 Bb1 Bbb1) = ~w(-2d -2m -2M -2A) |> from_c2.()
    assert ~w(Fbb2 Fb2 F2 F#2 F##2) = ~w(4dd 4d 4P 4A 4AA) |> from_c2.()
    assert ~w(G2 F1 G#2 Fb1) = ~w(5P -5P 5A -5A) |> from_c2.()
    assert ~w(A2 Eb1 Ab2 E1) = ~w(6M -6M 6m -6m) |> from_c2.()
  end

  test "transpose_from" do
    assert "G4" = Transpose.transpose_from("C4").("5P")
    assert ~w(C E G) = ~w(1P 3M 5P) |> Enum.map(&Transpose.transpose_from("C").(&1))
  end

  test "transpose_by" do
    assert "G4" = Transpose.transpose_by("5P").("C4")
    assert ~w(G A B) = ~w(C D E) |> Enum.map(&Transpose.transpose_by("5P").(&1))
  end
end
