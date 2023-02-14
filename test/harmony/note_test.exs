defmodule Harmony.NoteTest do
  use ExUnit.Case

  alias Harmony.Note

  test "get" do
    assert %Note{
             acc: "",
             alt: 0,
             chroma: 0,
             coord: [0, 4],
             freq: 261.6255653005986,
             height: 60,
             letter: "C",
             midi: 60,
             name: "C4",
             oct: 4,
             pc: "C",
             step: 0
           } = Note.get("C4")

    idempotence = Note.get("C4") |> Note.get()
    assert ^idempotence = Note.get("C4")
  end

  test "property shorthands" do
    assert "Db" = Note.name("db")
    assert "A##" = Note.pitch_class("Ax4")
    assert 1 = Note.chroma("db4")
    assert 61 = Note.midi("db4")
    assert 440.0 = Note.freq("A4")
  end

  test "simplify" do
    assert "C#" = Note.simplify("C#")
    assert "D" = Note.simplify("C##")
    assert "D#" = Note.simplify("C###")
    assert "C5" = Note.simplify("B#4")

    notes = ~w(C## C### F##4 Gbbb5 B#4 Cbb4)
    assert ~w(D D# G4 E5 C5 Bb3) = notes |> Enum.map(&Note.simplify(&1))
    assert "" = Note.simplify("x")
  end

  test "from midi" do
    assert "Bb4" = Note.from_midi(70).name
    assert ~w(C4 Db4 D4) = [60, 61, 62] |> Enum.map(&Note.from_midi(&1).name)
    assert ~w(C4 C#4 D4) = [60, 61, 62] |> Enum.map(&Note.from_midi_sharp(&1).name)
  end

  test "names" do
    assert ~w(C D E F G A B) = Note.names()
    assert ~w(F## Bb) = Note.names(["fx", "bb", 12, "nothing", %{}, nil])
  end

  test "sorted_names" do
    assert ~w(C F G A B) = Note.sorted_names(~w(c f g a b h j))
    assert ~w(C C F F G G A A B B) = Note.sorted_names(~w(c f g a b h j j h b a g f c))
    assert ~w(C C0 C1 C2 C5 C6) = Note.sorted_names(~w(c2 c5 c1 c0 c6 c))
    assert ~w(C6 C5 C2 C1 C0 C) = Note.sorted_names(~w(c2 c5 c1 c0 c6 c), :desc)
  end

  test "sorted_uniq_names" do
    assert ~w(C A B C2 C3) = Note.sorted_uniq_names(~w(a b c2 1p p2 c2 b c c3))
    assert ~w(C3 C2 B A C) = Note.sorted_uniq_names(~w(a b c2 1p p2 c2 b c c3), :desc)
  end

  test "from_freq" do
    assert "A4" = Note.from_freq(440.0).name
    assert "A4" = Note.from_freq(444.0).name
    assert "Bb4" = Note.from_freq(470.0).name
    assert "A#4" = Note.from_freq_sharp(470.0).name
    assert "" = Note.from_freq(0.0).name
    assert "" = Note.from_freq(nil).name
  end

  test "enharmonic" do
    assert "Db" = Note.enharmonic("C#")
    assert "D" = Note.enharmonic("C##")
    assert "Eb" = Note.enharmonic("C###")
    assert "C5" = Note.enharmonic("B#4")

    assert ~w(D Eb G4 E5 C5 A#3) =
             ~w(C## C### F##4 Gbbb5 B#4 Cbb4) |> Enum.map(&Note.enharmonic(&1))

    assert "" = Note.enharmonic("x")
    assert "E#2" = Note.enharmonic("F2", "E#")
    assert "Cb3" = Note.enharmonic("B2", "Cb")
    assert "B#1" = Note.enharmonic("C2", "B#")
    assert "" = Note.enharmonic("F2", "Eb")
  end

  test "tokenize" do
    assert ["C", "bb", "5", "major"] = Note.tokenize("Cbb5 major")
    assert ["A", "##", "", ""] = Note.tokenize("Ax")
    assert ["C", "", "", "M"] = Note.tokenize("CM")
    assert ["", "", "", "maj7"] = Note.tokenize("maj7")
    assert ["", "", "", ""] = Note.tokenize("")
    assert ["B", "b", "", ""] = Note.tokenize("bb")
    assert ["", "##", "", ""] = Note.tokenize("##")
  end
end
