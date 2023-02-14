defmodule Harmony.Note.Macros do
  alias Harmony.{Pitch, Util}

  @letters ~w(A B C D E F G)
  @accidentals ~w(bbb ### bb ## b # x) ++ [""]
  @octaves [nil] ++ Enum.to_list(-1..10)
  @notes List.flatten(
           for acc <- @accidentals do
             for note <- @letters do
               for octave <- @octaves do
                 {note, octave, acc}
               end
             end
           end
         )

  @semi [0, 2, 4, 5, 7, 9, 11]

  defmacro note_defs() do
    @notes
    |> Enum.map(fn {letter, octave, acc} ->
      octave_str = "#{octave}"
      note = letter <> acc <> octave_str
      down_note = String.downcase(letter) <> acc <> octave_str
      atom_note = String.to_atom(note)
      down_atom_note = String.to_atom(down_note)
      letter_char = letter |> String.to_charlist() |> List.first()
      step = rem(letter_char + 3, 7)
      alt = Util.to_alt(acc)
      pc_acc = Util.to_pc_acc(alt)
      pc = letter <> pc_acc
      name = letter <> pc_acc <> octave_str
      semi_step = Enum.at(@semi, step)
      chroma = rem(semi_step + alt + 120, 12)
      coord = Pitch.encode(%Pitch{step: step, alt: alt, oct: octave})

      height =
        if octave do
          semi_step + alt + 12 * (octave + 1)
        else
          rem(semi_step + alt, 12) - 12 * 99
        end

      midi = if height >= 0 && height <= 127, do: height
      freq = if octave, do: Float.pow(2.0, (height - 69) / 12) * 440
      simple = Util.to_note_name(midi || chroma, sharp: alt > 0, pitch_class: is_nil(midi))

      sharp_disabled = alt == 1 && letter in ["B", "E"]

      sharp_defs =
        if !is_nil(midi) and alt in [0, 1] && !sharp_disabled do
          quote location: :keep do
            def from_midi_sharp(unquote(midi)), do: get(unquote(note))
          end
        end

      flat_disabled = alt == -1 && letter in ["C", "F"]

      flat_defs =
        if !is_nil(midi) && alt in [0, -1] && !flat_disabled do
          quote location: :keep do
            def from_midi(unquote(midi)), do: get(unquote(note))
          end
        end

      get_defs =
        quote location: :keep do
          def get(unquote(down_note)), do: get(unquote(note))
          def get(unquote(atom_note)), do: get(unquote(note))
          def get(unquote(down_atom_note)), do: get(unquote(note))

          def get(unquote(note)) do
            %Harmony.Note{
              coord: unquote(coord),
              acc: unquote(acc),
              alt: unquote(alt),
              chroma: unquote(chroma),
              empty: false,
              freq: unquote(freq),
              height: unquote(height),
              letter: unquote(letter),
              midi: unquote(midi),
              name: unquote(name),
              oct: unquote(octave),
              pc: unquote(pc),
              simple: unquote(simple),
              step: unquote(step)
            }
          end
        end

      [flat_defs, sharp_defs, get_defs]
    end)
  end
end

defmodule Harmony.Note do
  alias __MODULE__
  alias Harmony.Note.Macros
  alias Harmony.Pitch
  alias Harmony.Util

  defstruct(
    acc: "",
    alt: nil,
    chroma: nil,
    coord: nil,
    empty: true,
    freq: nil,
    height: nil,
    letter: nil,
    midi: nil,
    name: "",
    note: "",
    oct: nil,
    pc: "",
    simple: "",
    step: nil
  )

  require Macros
  Macros.note_defs()

  def get(%Note{} = n), do: n
  def get(%Pitch{} = p), do: p |> Pitch.note_name() |> get()
  def get(_), do: %Note{}

  def simple(note), do: get(note).simple
  def octave(note), do: get(note).oct
  def simplify(note), do: get(note).simple
  def name(note), do: get(note).name
  def pitch_class(note), do: get(note).pc
  def chroma(note), do: get(note).chroma
  def midi(note), do: get(note).midi
  def freq(note), do: get(note).freq
  def height(note), do: get(note).height

  def names, do: ~w(C D E F G A B)

  def names(notes) do
    notes
    |> Enum.map(&get(&1).name)
    |> Enum.filter(&(&1 != ""))
  end

  def from_midi(nil), do: %Note{}

  def from_freq(nil), do: %Note{}
  def from_freq(0.0), do: %Note{}
  def from_freq(freq), do: freq |> Util.freq_to_midi() |> from_midi()

  def from_freq_sharp(nil), do: %Note{}
  def from_freq_sharp(0.0), do: %Note{}
  def from_freq_sharp(freq), do: freq |> Util.freq_to_midi() |> from_midi_sharp()

  def from_coord(coord) when is_list(coord), do: coord |> Pitch.decode() |> get()

  def sorted_names(notes) do
    notes
    |> names()
    |> Enum.sort(&(get(&1).height <= get(&2).height))
  end

  def sorted_names(notes, :desc) do
    notes
    |> names()
    |> Enum.sort(&(get(&1).height >= get(&2).height))
  end

  def sorted_uniq_names(notes) do
    notes
    |> sorted_names()
    |> Enum.uniq()
  end

  def sorted_uniq_names(notes, :desc) do
    notes
    |> sorted_names(:desc)
    |> Enum.uniq()
  end

  def enharmonic(src) when is_binary(src), do: src |> get() |> enharmonic()

  def enharmonic(%Note{midi: nil, alt: alt} = src) when alt < 0,
    do: enharmonic(src, from_midi_sharp(src.chroma).pc |> get())

  def enharmonic(%Note{alt: alt} = src) when alt < 0,
    do: enharmonic(src, from_midi_sharp(src.midi).pc |> get())

  def enharmonic(%Note{midi: nil} = src),
    do: enharmonic(src, from_midi(src.chroma).pc |> get())

  def enharmonic(%Note{} = src),
    do: enharmonic(src, from_midi(src.midi).pc |> get())

  def enharmonic(src, dest) when is_binary(src) or is_binary(dest),
    do: enharmonic(get(src), get(dest))

  def enharmonic(_, %Note{empty: true}), do: ""
  def enharmonic(%Note{empty: true}, _), do: ""
  def enharmonic(%Note{chroma: c1}, %Note{chroma: c2}) when c1 != c2, do: ""
  def enharmonic(%Note{oct: nil}, %Note{} = dest), do: dest.pc

  def enharmonic(%Note{} = src, %Note{} = dest) do
    src_chroma = src.chroma - src.alt
    dest_chroma = dest.chroma - dest.alt

    dest_oct_offset =
      cond do
        src_chroma > 11 || dest_chroma < 0 -> -1
        src_chroma < 0 || dest_chroma > 11 -> 1
        true -> 0
      end

    dest_oct = src.oct + dest_oct_offset
    "#{dest.pc}#{dest_oct}"
  end

  @noteregex ~r/^([a-gA-G]?)(\#{1,}|b{1,}|x{1,}|)(-?\d*)\s*(.*)$/

  def tokenize(str) when is_binary(str) do
    [[_, m1, m2, m3, m4]] = Regex.scan(@noteregex, str)
    [String.upcase(m1), String.replace(m2, ~r/x/, "##"), m3, m4]
  end

  def tokenize(_), do: ["", "", "", ""]
end
