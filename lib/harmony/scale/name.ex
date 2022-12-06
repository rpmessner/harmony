defmodule Harmony.Scale.Name do
  alias __MODULE__
  alias Harmony.Scale.Data
  alias Harmony.Pitch.ClassSet

  use GenServer

  defstruct(
    empty: true,
    name: "",
    set_num: 0,
    chroma: "000000000000",
    normalized: "000000000000",
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

  def get(type) do
    GenServer.call(@me, {:get, type})
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

  def handle_call({:keys}, _from, %State{} = s) do
    {:reply, Map.keys(s.index), s}
  end

  def handle_call({:reset}, _from, _arg) do
    {:reply, nil, default_state()}
  end

  def handle_call({:clear}, _from, _arg) do
    {:reply, nil, %State{}}
  end

  defp do_add(%State{} = s, intervals, name, aliases) do
    %{intervals: ivls, set_num: sn, chroma: ch, normalized: nrm} = ClassSet.get(intervals)

    entry = %Name{
      empty: false,
      name: name,
      set_num: sn,
      chroma: ch,
      normalized: nrm,
      intervals: ivls,
      aliases: aliases
    }

    %State{
      index: index_entry(s.index, entry, aliases),
      dictionary: [entry | s.dictionary]
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
