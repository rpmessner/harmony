defmodule Harmony.Pitch do
  alias __MODULE__
  alias Harmony.Util

  defstruct(
    step: 0,
    alt: 0,
    oct: nil,
    dir: nil
  )

  @type t :: %Pitch{
    step: integer(),
    alt: integer(),
    oct: integer() | nil,
    dir: integer() | nil
  }

  @types ~w(P M M P P M M)
  @fifths [0, 2, 4, -1, 1, 3, 5]
  @steps_to_octs Enum.map(@fifths, fn fifths ->
                   Integer.floor_div(fifths * 7, 12)
                 end)

  def coordinates(p), do: encode(p)

  def encode(%Pitch{dir: nil} = p), do: encode(%Pitch{p | dir: 1})

  def encode(%Pitch{oct: nil} = p) do
    %{step: step, alt: alt, dir: dir} = p
    f = Enum.at(@fifths, step) + 7 * alt
    [dir * f]
  end

  def encode(%Pitch{} = p) do
    %{step: step, alt: alt, oct: oct, dir: dir} = p
    f = Enum.at(@fifths, step) + 7 * alt
    o = oct - Enum.at(@steps_to_octs, step) - 4 * alt
    [dir * f, dir * o]
  end

  @fifths_to_steps [3, 0, 4, 1, 5, 2, 6]

  def decode([f]), do: decode([f, nil, 1])
  def decode([f, o]), do: decode([f, o, 1])

  def decode([f, o, dir]) do
    step = Enum.at(@fifths_to_steps, unaltered(f))
    alt = Integer.floor_div(f + 1, 7)

    if is_nil(o) do
      %Pitch{step: step, alt: alt, dir: dir}
    else
      oct = o + 4 * alt + Enum.at(@steps_to_octs, step)
      %Pitch{step: step, alt: alt, oct: oct, dir: dir}
    end
  end

  @sizes [0, 2, 4, 5, 7, 9, 11]

  def height(%Pitch{oct: nil} = p), do: height(%Pitch{p | oct: -100})
  def height(%Pitch{dir: nil} = p), do: height(%Pitch{p | dir: 1})

  def height(%Pitch{} = p) do
    %{alt: alt, dir: dir, oct: oct, step: step} = p
    dir * (Enum.at(@sizes, step) + alt + 12 * oct)
  end

  def midi(%Pitch{oct: nil}), do: nil

  def midi(%Pitch{} = p) do
    case height(p) do
      h when h >= 12 and h <= 115 -> h + 12
      _ -> nil
    end
  end

  def chroma(%Pitch{} = p) do
    %{step: step, alt: alt} = p
    rem(Enum.at(@sizes, step) + alt + 120, 12)
  end

  def get([f]) do
    step = Enum.at(@fifths_to_steps, unaltered(f))
    alt = Integer.floor_div(f + 1, 7)
    %Pitch{step: step, alt: alt}
  end

  def get([f, o]) do
    %{step: step, alt: alt} = get([f])
    oct = o + 4 * alt + Enum.at(@steps_to_octs, step)
    %Pitch{step: step, alt: alt, oct: oct}
  end

  @letters ~w(C D E F G A B)

  def note_name(%Pitch{step: nil}), do: ""

  def note_name(%Pitch{} = p) do
    %{step: step, alt: alt, oct: oct} = p
    letter = Enum.at(@letters, step)
    "#{letter}#{Util.alt_to_acc(alt)}#{oct}"
  end

  def interval_name(%Pitch{oct: nil} = p), do: %Pitch{p | oct: 0}
  def interval_name(%Pitch{dir: nil}), do: ""

  def interval_name(%Pitch{} = p) do
    %{step: step, alt: alt, oct: oct, dir: dir} = p
    calc_num = step + 1 + 7 * oct
    num = if calc_num == 0, do: step + 1, else: calc_num
    d = if dir < 0, do: "-", else: ""
    type = if Enum.at(@types, step) == "M", do: "majorable", else: "perfectable"
    "#{d}#{num}#{Util.alt_to_q(type, alt)}"
  end

  defp unaltered(f) do
    i = rem(f + 1, 7)
    if i < 0, do: 7 + i, else: i
  end
end
