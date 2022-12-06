defmodule Harmony.Pitch.ClassSet.Macros do
  alias Harmony.Util

  @chromas 1..4095
           |> Enum.map(&Util.set_num_to_chroma/1)

  defp chroma_to_number(chroma) do
    case Integer.parse(chroma, 2) do
      {n, ""} -> n
      _ -> 0
    end
  end

  @ivls ~w(1P 2m 2M 3m 3M 4P 5d 5P 6m 6M 7m 7M)

  defp chroma_to_intervals(chroma) do
    chroma
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn
      {"1", i} -> Enum.at(@ivls, i)
      _ -> nil
    end)
    |> Enum.reject(&is_nil/1)
  end

  defmacro class_set_defs() do
    get_defs =
      @chromas
      |> Enum.map(fn chroma ->
        set_num = chroma_to_number(chroma)

        normalized_num =
          chroma
          |> Util.chroma_rotations()
          |> Enum.map(&chroma_to_number/1)
          |> Enum.filter(&(&1 >= 2048))
          |> Enum.sort()
          |> List.first()

        normalized = Util.set_num_to_chroma(normalized_num)
        intervals = chroma_to_intervals(chroma)

        quote location: :keep do
          def get(unquote(chroma)) do
            %Harmony.Pitch.ClassSet{
              empty: false,
              set_num: unquote(set_num),
              chroma: unquote(chroma),
              normalized: unquote(normalized),
              intervals: unquote(intervals)
            }
          end
        end
      end)

    chromas_def =
      quote location: :keep do
        def chromas do
          unquote(
            2048..4095
            |> Enum.map(&Util.set_num_to_chroma/1)
          )
        end
      end

    [get_defs, chromas_def]
  end
end

defmodule Harmony.Pitch.ClassSet do
  alias __MODULE__
  alias Harmony.Pitch.ClassSet.Macros
  alias Harmony.{Note, Interval, Util}

  defstruct(
    empty: true,
    set_num: 0,
    chroma: "000000000000",
    normalized: "000000000000",
    intervals: []
  )

  require Macros
  Macros.class_set_defs()

  def get("000000000000"), do: %ClassSet{}
  def get(%ClassSet{} = cs), do: cs

  def get(set) when is_integer(set) and set >= 0 and set <= 4095,
    do: get(Util.set_num_to_chroma(set))

  def get([]), do: %ClassSet{}

  @zeros List.duplicate(0, 12)

  def get(set) when is_list(set) do
    Enum.reduce(set, @zeros, fn item, binary ->
      replace = &List.replace_at(binary, &1, 1)

      case {Note.get(item), Interval.get(item)} do
        {%{empty: false, chroma: chroma}, _} ->
          replace.(chroma)

        {_, %{empty: false, chroma: chroma}} ->
          replace.(chroma)

        _ ->
          binary
      end
    end)
    |> Enum.join()
    |> get()
  end

  def get(_), do: %ClassSet{}

  def num(pcs), do: get(pcs).set_num
  def chroma(pcs), do: get(pcs).chroma
  def intervals(pcs), do: get(pcs).intervals

  def is_note_included_in(set) when is_binary(set) or is_list(set),
    do: set |> get() |> is_note_included_in()

  def is_note_included_in(%ClassSet{empty: true}),
    do: fn _ -> false end

  def is_note_included_in(%ClassSet{} = s) do
    %{chroma: schr} = s

    fn name ->
      case Note.get(name) do
        %{empty: true} -> false
        %{chroma: nchr} -> String.at(schr, nchr) == "1"
      end
    end
  end

  def filter(set) do
    is_included = is_note_included_in(set)

    fn notes when is_list(notes) ->
      Enum.filter(notes, &is_included.(&1))
    end
  end

  def is_equal(s1, s2), do: get(s1).set_num == get(s2).set_num

  def is_subset_of(set) do
    is_set_of(set, &Bitwise.band/2)
  end

  def is_superset_of(set) do
    is_set_of(set, &Bitwise.bor/2)
  end

  defp is_set_of(set, op) when is_binary(set) or is_list(set),
    do: set |> get() |> is_set_of(op)

  defp is_set_of(%ClassSet{set_num: nil}, _),
    do: fn -> false end

  defp is_set_of(%ClassSet{} = set, op) do
    %{set_num: s} = set

    fn notes ->
      o = get(notes).set_num
      opr = op.(o, s)
      s != o && opr == o
    end
  end

  def modes(set), do: modes(set, true)

  def modes(set, n) when is_binary(set) or is_list(set),
    do: modes(get(set), n)

  def modes(%ClassSet{} = pcs, n) do
    %{chroma: chroma} = pcs
    Util.chroma_rotations(chroma, n)
  end
end
