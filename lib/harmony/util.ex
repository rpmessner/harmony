defmodule Harmony.Util do
  def alt_to_q("majorable", 0), do: "M"
  def alt_to_q(_, 0), do: "P"
  def alt_to_q("majorable", -1), do: "m"
  def alt_to_q(_, alt) when alt > 0, do: String.duplicate("A", alt)
  def alt_to_q("perfectable", alt) when alt <= 0, do: String.duplicate("d", -alt)
  def alt_to_q(_, alt) when alt <= 0, do: String.duplicate("d", -(alt + 1))

  def q_to_alt("majorable", "M"), do: 0
  def q_to_alt("perfectable", "P"), do: 0
  def q_to_alt("majorable", "m"), do: -1
  def q_to_alt(_, "A"), do: 1
  def q_to_alt(_, "AA"), do: 2
  def q_to_alt(_, "AAA"), do: 3
  def q_to_alt(_, "AAAA"), do: 4
  def q_to_alt("perfectable", "d"), do: -1
  def q_to_alt("perfectable", "dd"), do: -2
  def q_to_alt("perfectable", "ddd"), do: -3
  def q_to_alt("perfectable", "dddd"), do: -4
  def q_to_alt(_, "d"), do: -2
  def q_to_alt(_, "dd"), do: -3
  def q_to_alt(_, "ddd"), do: -4
  def q_to_alt(_, "dddd"), do: -5
  def q_to_alt(_, _), do: 0

  def alt_to_acc(alt) when alt < 0, do: String.duplicate("b", -alt)
  def alt_to_acc(alt), do: String.duplicate("#", alt)

  def acc_to_alt(""), do: 0
  def acc_to_alt("x"), do: 2
  def acc_to_alt("b"), do: -1
  def acc_to_alt("bb"), do: -2
  def acc_to_alt("bbb"), do: -3
  def acc_to_alt("#"), do: 1
  def acc_to_alt("##"), do: 2
  def acc_to_alt("###"), do: 3
  def acc_to_alt(_), do: nil

  @sharps ~w(C C# D D# E F F# G G# A A# B)
  @flats ~w(C Db D Eb E F Gb G Ab A Bb B)

  def to_note_name(nil, _), do: ""
  def to_note_name(midi, sharp: false, pitch_class: true), do: to_note_name(midi, @flats, false)
  def to_note_name(midi, sharp: true, pitch_class: true), do: to_note_name(midi, @sharps, false)
  def to_note_name(midi, sharp: true, pitch_class: false), do: to_note_name(midi, @sharps, true)
  def to_note_name(midi, sharp: false, pitch_class: false), do: to_note_name(midi, @flats, true)

  def to_note_name(midi, notes, octave) do
    pc = Enum.at(notes, rem(midi, 12))
    o = if octave, do: Integer.floor_div(midi, 12) - 1
    "#{pc}#{o}"
  end

  def to_alt(""), do: 0
  def to_alt("#" <> rest), do: 1 + to_alt(rest)
  def to_alt("b" <> rest), do: -1 + to_alt(rest)
  def to_alt("x" <> rest), do: 2 + to_alt(rest)

  def to_pc_acc(0), do: ""
  def to_pc_acc(n) when n > 0, do: "#" <> to_pc_acc(n - 1)
  def to_pc_acc(n) when n < 0, do: "b" <> to_pc_acc(n + 1)

  @l2 :math.log(2.0)
  @l440 :math.log(440.0)

  def freq_to_midi(freq) do
    v = 12.0 * (:math.log(freq) - @l440) / @l2 + 69.0
    v = Float.round(v * 100.0) / 100.0
    trunc(v)
  end

  def set_num_to_chroma(num),
    do: Integer.to_string(num, 2) |> String.pad_leading(12, "0")

  def rotate(times, list) do
    len = Enum.count(list)
    n = rem(rem(times, len) + len, len)

    Enum.concat(
      Enum.slice(list, n, len),
      Enum.slice(list, 0, n)
    )
  end

  def chroma_rotations(chroma, n \\ false) do
    binary = String.graphemes(chroma)

    binary
    |> Enum.with_index()
    |> Enum.map(fn {_, i} ->
      case rotate(i, binary) do
        ["0" | _] when n -> nil
        r -> Enum.join(r)
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end
