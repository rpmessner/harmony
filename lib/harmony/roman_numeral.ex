defmodule Harmony.RomanNumeral.Macros do
  alias Harmony.{Pitch, Interval, Util}

  @minors ~w(i ii iii iv v vi vii)
  @majors ~w(I II III IV V VI VII)
  @accidentals ~w(bbb ### bb ## b # x) ++ [""]
  @romans List.flatten(
            for r <- Enum.reverse(@minors) ++ Enum.reverse(@majors) do
              for a <- @accidentals, do: {r, a}
            end
          )

  @invalid_names List.flatten(
                   for(roman <- @minors, do: for(inv <- @majors, do: {roman, inv})) ++
                     for(roman <- @majors, do: for(inv <- @minors, do: {roman, inv}))
                 )

  defmacro roman_numeral_defs() do
    invalid_defs =
      @invalid_names
      |> Enum.map(fn {roman, inv} ->
        quote location: :keep do
          def get(unquote("#{roman}#{inv}")), do: %Harmony.RomanNumeral{}
        end
      end)

    get_defs =
      @romans
      |> Enum.map(fn {roman, acc} ->
        name = "#{acc}#{roman}"

        upper_roman = roman |> String.upcase()
        step = Enum.find_index(@majors, &(&1 == upper_roman))
        alt = Util.acc_to_alt(acc)
        dir = 1

        quote location: :keep do
          def get(unquote(name) <> rest) do
            %Harmony.RomanNumeral{
              empty: false,
              name: unquote(name) <> rest,
              roman: unquote(roman),
              interval:
                Interval.get(%Pitch{
                  step: unquote(step),
                  dir: unquote(dir),
                  alt: unquote(alt)
                }).name,
              acc: unquote(acc),
              chord_type: rest,
              major: unquote(roman == upper_roman),
              step: unquote(step),
              alt: unquote(alt),
              oct: 0,
              dir: unquote(dir)
            }
          end
        end
      end)

    [invalid_defs, get_defs]
  end
end

defmodule Harmony.RomanNumeral do
  alias __MODULE__
  alias Harmony.RomanNumeral.Macros
  alias Harmony.{Interval, Pitch, Util}

  defstruct(
    empty: true,
    name: "",
    roman: "",
    interval: "",
    acc: "",
    chord_type: "",
    major: true,
    step: nil,
    alt: nil,
    oct: nil,
    dir: nil
  )

  require Macros
  Macros.roman_numeral_defs()

  @names ~w(I II III IV V VI VII)
  @minors ~w(i ii iii iv v vi vii)

  def names, do: @names
  def names(false), do: @minors

  def get(n) when is_integer(n) and n < 7 and n >= 0,
    do: get(Enum.at(@names, n))

  def get(%Interval{} = i),
    do: get(Interval.pitch(i))

  def get(%Pitch{} = p),
    do: get("#{Util.alt_to_acc(p.alt)}#{Enum.at(@names, p.step)}")

  def get(_), do: %RomanNumeral{}

  def pitch(%RomanNumeral{} = r),
    do: %Pitch{alt: r.alt, oct: r.oct, step: r.step, dir: r.dir}
end
