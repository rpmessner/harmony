defmodule Harmony.Pitch.ClassSetTest do
  use ExUnit.Case

  alias Harmony.Pitch.ClassSet

  test "from note list" do
    assert %ClassSet{
             empty: false,
             set_num: 2688,
             chroma: "101010000000",
             normalized: "100000001010",
             intervals: ~w(1P 2M 3M)
           } = ~w(c d e) |> ClassSet.get()

    cde = ClassSet.get(~w(c d e))
    assert ^cde = ClassSet.get(~w(d e c))
    assert true = ClassSet.get(["not a note or interval"]).empty
    assert true = ClassSet.get([]).empty
  end

  test "from pcset number" do
    c = ClassSet.get(~w(C))
    assert ^c = ClassSet.get(2048)
  end

  test "num" do
    assert 1 = ClassSet.num("000000000001")
    assert 1 = ClassSet.num(~w(B))
    assert 1 = ClassSet.num(~w(Cb))
    assert 2192 = ClassSet.num(~w(C E G))
    assert 2048 = ClassSet.num(~w(C))
    assert 2048 = ClassSet.num("100000000000")
    assert 4095 = ClassSet.num("111111111111")
  end

  test "normalized" do
    # 100000000000
    like_c = ClassSet.get(["C"]).chroma

    for pc <- ~w(c d e f g a b) do
      assert ^like_c = ClassSet.get([pc]).normalized
    end

    normalized = ClassSet.get(["C", "D"]).normalized
    assert ^normalized = ClassSet.get(["E", "F#"]).normalized
  end

  test "chroma" do
    assert "100000000000" = ~w(C) |> ClassSet.chroma()
    assert "001000000000" = ~w(D) |> ClassSet.chroma()
    assert "101010000000" = ~w(c d e) |> ClassSet.chroma()
    assert "000000011110" = ~w(g g#4 a bb5) |> ClassSet.chroma()

    c_maj = ClassSet.chroma(~w(c d e f g a b))
    assert ^c_maj = ~w(P1 M2 M3 P4 P5 M6 M7) |> ClassSet.chroma()

    assert "101010101010" = ClassSet.chroma("101010101010")
    assert "000000000000" = ClassSet.chroma(~w(one two))
    assert "000000000000" = ClassSet.chroma("A B C")
  end

  test "chromas" do
    assert 2048 = ClassSet.chromas() |> Enum.count()
    assert "100000000000" = ClassSet.chromas() |> List.first()
    assert "111111111111" = ClassSet.chromas() |> List.last()
  end

  test "intervals" do
    assert ~w(1P 2M 3M 5d 6m 7m) = ClassSet.intervals("101010101010")
    assert [] = ClassSet.intervals("1010")
    assert ~w(1P 5P 7M) = ~w(C G B) |> ClassSet.intervals()
    assert ~w(2M 4P 6M) = ~w(D F A) |> ClassSet.intervals()
  end

  test "is_subset_of" do
    is_in_c_major = ~w(c4 e6 g) |> ClassSet.is_subset_of()
    assert is_in_c_major.(~w(c2 g7))
    assert is_in_c_major.(~w(c2 e))
    refute is_in_c_major.(~w(c2 e3 g4))
    refute is_in_c_major.(~w(c2 e3 b5))
    assert ClassSet.is_subset_of(~w(c d e)).(~w(C D))
  end

  test "is_subset_of with chroma" do
    is_subset = ClassSet.is_subset_of("101010101010")
    assert is_subset.("101000000000")
    refute is_subset.("111000000000")
  end

  test "is_superset_of" do
    extends_c_major = ~w(c e g) |> ClassSet.is_superset_of()
    assert extends_c_major.(~w(c2 g3 e4 f5))
    refute extends_c_major.(~w(e c g))
    refute extends_c_major.(~w(c e f))
    assert ClassSet.is_superset_of(~w(c d)).(~w(c d e))
  end

  test "is_superset_of with chroma" do
    is_superset = ClassSet.is_superset_of("101000000000")
    assert is_superset.("101010101010")
    refute is_superset.("110010101010")
  end

  test "is_equal" do
    assert ClassSet.is_equal(~w(c2 d3 e7 f5), ~w(c4 c d5 e6 f1))
    assert ClassSet.is_equal(~w(c f), ~w(c4 c f1))
  end

  test "is_note_included_in" do
    is_included_in_c = ~w(c d e) |> ClassSet.is_note_included_in()
    assert is_included_in_c.("C4")
    refute is_included_in_c.("C#4")
  end

  test "filter" do
    in_c_major = ~w(c d e) |> ClassSet.filter()
    assert ~w(c2 d2 c3 d3) = in_c_major.(~w(c2 c#2 d2 c3 c#3 d3))
    assert ~w(c2 c3) = ClassSet.filter(~w(c)).(~w(c2 c#2 d2 c3 c#3 d3))
  end

  test "modes" do
    assert ~w(
      101011010101
      101101010110
      110101011010
      101010110101
      101011010110
      101101011010
      110101101010
    ) = ~w(c d e f g a b) |> ClassSet.modes()

    assert ~w(
        101011010101
        010110101011
        101101010110
        011010101101
        110101011010
        101010110101
        010101101011
        101011010110
        010110101101
        101101011010
        011010110101
        110101101010
      ) = ~w(c d e f g a b) |> ClassSet.modes(false)

    assert [] = ClassSet.modes(["blah", "bleh"])
  end
end
