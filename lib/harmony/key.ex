defmodule Harmony.Key do
  #   defmodule Major do
  #     defstruct(
  #       tonic: "",
  #       grades: [],
  #       intervals: [],
  #       scale: [],
  #       chords: [],
  #       chords_harmonic_function: [],
  #       chord_scales: [],
  #       minor_relative: "",
  #       alteration: "",
  #       key_signature: "",
  #       secondary_dominants: [],
  #       secondary_dominants_minor_relative: [],
  #       substitute_dominants: [],
  #       substitute_dominants_minor_relative: []
  #     )
  #   end

  #   defmodule Minor do
  #     defstruct(
  #       type: "minor",
  #       tonic: "",
  #       relative_major: "",
  #       alteration: "",
  #       key_signature: "",
  #       natural: [],
  #       harmonic: [],
  #       melodic: []
  #     )
  #   end

  alias Harmony.{Transpose, Util}
  #   alias Harmony.RomanNumeral, as: Roman

  def major_tonic_from_key_signature(0), do: "C"

  def major_tonic_from_key_signature(alt) when is_integer(alt) do
    Transpose.transpose_fifths("C", alt)
  end

  def major_tonic_from_key_signature(acc) do
    Transpose.transpose_fifths("C", Util.acc_to_alt(acc))
  end

  #   defp key_scale(grades, chords, harmonic_fcnctions, chord_scales) do
  #     fn tonic ->
  #       intervals =
  #         Enum.map(grades, fn gr ->
  #           Roman.get(gr).interval || ""
  #         end)

  #       scale =
  #         Enum.map(intervals, fn interval ->
  #           Transpose.transpose(tonic, interval)
  #         end)

  #       %{
  #         tonic: tonic,
  #         grades: grades,
  #         intervals: intervals,
  #         scale: scale,
  #         chords: map_scale_to_type(scale, chords),
  #         chords_harmonic_function: harmonic_functions,
  #         chordScales: map_scale_to_type(scale, chord_scales, " ")
  #       }
  #     end
  #   end

  #   defp major_scale do
  #     key_scale(
  #       ~w(I II III IV V VI VII),
  #       ~w(maj7 m7 m7 maj7 7 m7 m7b5),
  #       ~w(T SD T SD D T D),
  #       ~w(major dorian phrygian lydian mixolydian minor locrian)
  #     )
  #   end

  #   defp natural_scale do
  #     key_scale(
  #       ~w(I II bIII IV V bVI bVII),
  #       ~w(m7 m7b5 maj7 m7 m7 maj7 7),
  #       ~w(T SD T SD D SD SD),
  #       ~w(minor locrian major dorian phrygian lydian mixolydian)
  #     )
  #   end

  #   defp harmonic_scale do
  #     key_scale(
  #       ~w(I II bIII IV V bVI VII),
  #       ~w(mMaj7 m7b5 +maj7 m7 7 maj7 o7),
  #       ~w(T SD T SD D SD D),
  #       "harmonic minor,locrian 6,major augmented,lydian diminished,phrygian dominant,lydian #9,ultralocrian"
  #       |> String.split(",")
  #     )
  #   end

  #   def melodic_scale do
  #     key_scale(
  #       ~w(I II bIII IV V VI VII),
  #       ~w(m6 m7 +maj7 7 7 m7b5 m7b5),
  #       ~w(T SD T SD D) ++ ["", ""],
  #       [
  #         "melodic minor",
  #         "dorian b2",
  #         "lydian augmented",
  #         "lydian dominant",
  #         "mixolydian b6",
  #         "locrian #2,altered"
  #       ]
  #     )
  #   end

  #   def major_key(tonic) do
  #     case Note.get(tonic) do
  #       %{empty: true} ->
  #         %Major{}

  #       %{pc: pc} ->
  #         key_scale = major_scale.(pc)
  #         alteration = dist_in_fifths("C", pc)

  #         roman_in_tonic = fn src ->
  #           r = RomanNumeral.get(src)

  #           if r.empty do
  #             ""
  #           else
  #             Transpose.transpose(tonic, r.interval) + r.chord_type
  #           end
  #         end

  #         %Major{
  #           key_scale: key_scale,
  #           type: "major",
  #           minor_relative: Transpose.transpose(pc, "-3m"),
  #           alteration: alteration,
  #           key_signature: Util.alt_to_acc(alteration),
  #           secondary_dominants:
  #             ~w(- VI7 VII7 I7 II7 III7 -)
  #             |> Enum.map(&roman_in_tonic.(&1)),
  #           secondary_dominants_minor_relative:
  #             ~w(- IIIm7b5 IV#m7 Vm7 VIm7 VIIm7b5 -)
  #             |> Enum.map(&roman_in_tonic.(&1)),
  #           substitute_dominants:
  #             ~w(- bIII7 IV7 bV7 bVI7 bVII7 -)
  #             |> Enum.map(&roman_in_tonic.(&1)),
  #           substitute_dominants_minor_relative:
  #             ~w(- IIIm7 Im7 IIbm7 VIm7 IVm7 -)
  #             |> Enum.map(&roman_in_tonic.(&1))
  #         }
  #     end
  #   end

  #   def minor_key(n) do
  #     pc = Note.get(n).pc

  #     alteration = dist_in_fifths("C", pc) - 3

  #     %Minor{
  #       type: "minor",
  #       tonic: pc,
  #       relative_major: Transpose.transpose(pc, "3m"),
  #       alteration: alteration,
  #       keySignature: Util.alt_to_acc(alteration),
  #       natural: natural_scale.(pc),
  #       harmonic: harmonic_scale.(pc),
  #       melodic: melodic_scale.(pc)
  #     }
  #   end

  #   defp dist_in_fifths(from, to) do
  #     f = Note.get(from)
  #     t = Note.get(to)
  #     if f.empty || t.empty, do: 0, else: List.first(t.coord) - List.first(f.coor)
  #   end

  #   defp map_scale_to_type(scale, list, sep \\ "") do
  #     Enum.map(list, fn type, i ->
  #       "#{Enum.at(scale, i)}#{sep}#{type}"
  #     end)
  #   end
end
