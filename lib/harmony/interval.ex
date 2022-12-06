defmodule Harmony.Interval.Macros do
  alias Harmony.Util
  alias Harmony.Pitch

  @qualities ~w(dddd ddd dd d m M P A AA AAA AAAA)
  @numbers Enum.to_list(-20..20)

  @intervals List.flatten(
               for qual <- @qualities do
                 for num <- @numbers, do: {qual, num}
               end
             )

  @types ~w(P M M P P M M)
  @sizes [0, 2, 4, 5, 7, 9, 11]

  defmacro interval_defs() do
    @intervals
    |> Enum.map(fn {q, num} ->
      step = rem(abs(num) - 1, 7)
      t = Enum.at(@types, step)
      type = if t == "M", do: "majorable", else: "perfectable"
      simplified = "#{simple_num(num)}#{q}"
      name = "#{num}#{q}"
      reverse_name = "#{q}#{num}"
      dir = if num < 0, do: -1, else: 1
      simple = if num === 8 || num === -8, do: num, else: dir * (step + 1)
      alt = Util.q_to_alt(type, q)
      oct = Integer.floor_div(abs(num) - 1, 7)
      semitones = dir * (Enum.at(@sizes, step) + alt + 12 * oct)
      chroma = rem(rem(dir * (Enum.at(@sizes, step) + alt), 12) + 12, 12)
      coord = Pitch.encode(%Pitch{step: step, alt: alt, oct: oct, dir: dir})

      quote location: :keep do
        def get(unquote(reverse_name)), do: get(unquote(name))

        def get(unquote(name)) do
          %Harmony.Interval{
            empty: false,
            name: unquote(name),
            num: unquote(num),
            q: unquote(q),
            step: unquote(step),
            alt: unquote(alt),
            dir: unquote(dir),
            type: unquote(type),
            simple: unquote(simple),
            simplified: unquote(simplified),
            semitones: unquote(semitones),
            chroma: unquote(chroma),
            coord: unquote(coord),
            oct: unquote(oct)
          }
        end
      end
    end)
  end

  defp simple_num(n) when n < -8, do: rem(n + 1, 7) - 1
  defp simple_num(n) when n > 8, do: rem(n - 1, 7) + 1
  defp simple_num(n), do: n
end

defmodule Harmony.Interval do
  alias __MODULE__
  alias Harmony.{Note, Pitch, RomanNumeral}
  alias Harmony.Interval.Macros

  require Macros

  defstruct(
    alt: nil,
    chroma: nil,
    coord: nil,
    dir: nil,
    empty: true,
    name: "",
    num: nil,
    oct: nil,
    q: "",
    semitones: nil,
    simple: nil,
    simplified: nil,
    step: nil,
    type: ""
  )

  Macros.interval_defs()

  def get(%RomanNumeral{} = r), do: get(RomanNumeral.pitch(r))
  def get(%Interval{} = i), do: get(Interval.pitch(i))
  def get(%Pitch{} = p), do: p |> Pitch.interval_name() |> get()
  def get(_), do: %Interval{}

  def pitch(%Interval{} = i),
    do: %Pitch{alt: i.alt, oct: i.oct, step: i.step, dir: i.dir}

  @names ~w(1P 2M 3M 4P 5P 6m 7m)
  def names(), do: @names

  def name(name) when is_binary(name), do: get(name).name

  def num(name), do: get(name).num
  def quality(name), do: get(name).q
  def semitones(name), do: get(name).semitones
  def simple(name), do: get(name).simple
  def simplify(name), do: get(name).simplified

  def distance(%Note{empty: true}, _), do: ""
  def distance(_, %Note{empty: true}), do: ""

  def distance(%Note{} = from, %Note{} = to) do
    fcoord = from.coord
    tcoord = to.coord
    fifths = List.first(tcoord) - List.first(fcoord)

    octs =
      if Enum.count(fcoord) == 2 && Enum.count(tcoord) == 2 do
        Enum.at(tcoord, 1) - Enum.at(fcoord, 1)
      else
        -Integer.floor_div(fifths * 7, 12)
      end

    force_descending =
      to.height == from.height &&
        !is_nil(to.midi) &&
        !is_nil(from.midi) &&
        from.step > to.step

    from_coord([fifths, octs], force_descending).name
  end

  def distance(from, to) when is_binary(from) and is_binary(to) do
    distance(Note.get(from), Note.get(to))
  end

  def invert(name) do
    case get(name) do
      %Interval{empty: true} ->
        ""

      %Interval{} = i ->
        %{type: type, step: step, alt: alt, oct: oct, dir: dir} = i
        step = rem(7 - step, 7)
        alt = if type == "perfectable", do: -alt, else: -(alt + 1)
        Pitch.interval_name(%Pitch{step: step, alt: alt, oct: oct, dir: dir})

      _ ->
        ""
    end
  end

  def from_coord(pc), do: from_coord(pc, false)
  def from_coord([f], fd), do: from_coord([f, 0], fd)
  def from_coord([f, o | _], true), do: [-f, -o, -1] |> Pitch.decode() |> get()

  def from_coord([f, o | _], _) when f * 7 + o * 12 < 0,
    do: [-f, -o, -1] |> Pitch.decode() |> get()

  def from_coord([f, o | _], _), do: [f, o, 1] |> Pitch.decode() |> get()

  @numbers [1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 7]
  @qualities ~w(P m M m M P d P m M m M)

  def from_semitones(s) when s < 0, do: from_semitones(s, -1)
  def from_semitones(s), do: from_semitones(s, 1)

  def from_semitones(semitones, dir) do
    num = abs(semitones)
    i = rem(num, 12)
    oct = Integer.floor_div(num, 12)
    num = dir * (Enum.at(@numbers, i) + 7 * oct)
    qual = Enum.at(@qualities, i)
    "#{num}#{qual}"
  end

  def add(a, b) do
    arithmetic(a, b, fn [a0, a1], [b0, b1] -> [a0 + b0, a1 + b1] end)
  end

  def add_to(a) do
    fn b ->
      arithmetic(a, b, fn [a0, a1], [b0, b1] -> [a0 + b0, a1 + b1] end)
    end
  end

  def subtract(a, b) do
    arithmetic(a, b, fn [a0, a1], [b0, b1] -> [a0 - b0, a1 - b1] end)
  end

  defp arithmetic(a, b, op) when is_binary(a) and is_binary(b) do
    arithmetic(get(a).coord, get(b).coord, op)
  end

  defp arithmetic(a, b, op) when is_list(a) and is_list(b) do
    from_coord(op.(a, b)).name
  end
end
