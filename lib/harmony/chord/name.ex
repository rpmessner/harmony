defmodule Harmony.Chord.Name do
  alias __MODULE__
  alias Harmony.Chord.Data
  alias Harmony.Pitch.ClassSet

  use GenServer

  defstruct(
    empty: true,
    set_num: 0,
    chroma: "000000000000",
    normalized: "000000000000",
    name: "",
    quality: "",
    intervals: [],
    aliases: []
  )

  @me __MODULE__

  defmodule State do
    defstruct(
      index: %{},
      dictionary: []
    )
  end

  def get(name) do
    GenServer.call(@me, {:get, name})
  end

  def all() do
    GenServer.call(@me, {:all})
  end

  def reset() do
    GenServer.call(@me, {:reset})
  end

  def clear() do
    GenServer.call(@me, {:clear})
  end

  def keys() do
    GenServer.call(@me, {:keys})
  end

  def names() do
    GenServer.call(@me, {:names})
  end

  def symbols() do
    GenServer.call(@me, {:symbols})
  end

  def add(intervals, name, aliases \\ []) do
    GenServer.call(@me, {:add, intervals, name, aliases})
  end

  def start_link(_state) do
    GenServer.start_link(@me, default_state(), name: @me)
  end

  defp default_state() do
    Data.data()
    |> Enum.reverse()
    |> Enum.reduce(%State{}, fn {intervals, name, aliases}, s ->
      do_add(s, intervals, name, aliases)
    end)
  end

  def init(%State{} = s) do
    {:ok, s}
  end

  def handle_call({:add, intervals, name, aliases}, _from, %State{} = s) do
    {:reply, nil, do_add(s, intervals, name, aliases)}
  end

  def handle_call({:all}, _from, %State{} = s) do
    {:reply, s.dictionary, s}
  end

  def handle_call({:get, name}, _from, %State{} = s) do
    {:reply, Map.get(s.index, name, %Name{}), s}
  end

  def handle_call({:names}, _from, %State{} = s) do
    names = s.dictionary |> Enum.map(& &1.name) |> Enum.filter(&(&1 != ""))
    {:reply, names, s}
  end

  def handle_call({:symbols}, _from, %State{} = s) do
    symbols =
      s.dictionary
      |> Enum.map(&(&1.aliases |> List.first()))
      |> Enum.filter(&(!(&1 in ["", nil])))

    {:reply, symbols, s}
  end

  def handle_call({:keys}, _from, %State{} = s) do
    {:reply, Map.keys(s.index), s}
  end

  def handle_call({:reset}, _from, _arg) do
    {:reply, nil, default_state()}
  end

  def handle_call({:clear}, _from, _arg) do
    {:reply, nil, %State{}}
  end

  def quality(intervals) do
    cond do
      "5A" in intervals -> "Augmented"
      "3M" in intervals -> "Major"
      "5d" in intervals -> "Diminished"
      "3m" in intervals -> "Minor"
      true -> "Unknown"
    end
  end

  def do_add(%State{} = s, intervals, name, aliases) do
    quality = quality(intervals)

    %{set_num: sn, chroma: ch, normalized: nrm} = ClassSet.get(intervals)

    entry = %Name{
      empty: false,
      name: name,
      set_num: sn,
      chroma: ch,
      normalized: nrm,
      intervals: intervals,
      aliases: aliases,
      quality: quality
    }

    dictionary = [entry | s.dictionary] |> Enum.sort_by(& &1.set_num)

    %State{
      index: index_entry(s.index, entry, aliases),
      dictionary: dictionary
    }
  end

  def index_entry(index, entry, aliases) do
    index
    |> Map.put(entry.name, entry)
    |> Map.put(entry.set_num, entry)
    |> Map.put(entry.chroma, entry)
    |> (&Enum.reduce(aliases, &1, fn a, idx ->
          Map.put(idx, a, entry)
        end)).()
  end
end
