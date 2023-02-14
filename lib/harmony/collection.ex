defmodule Harmony.Collection do
  def range(from, to) do
    if from < to do
      asc_r(from, to - from + 1)
    else
      desc_r(from, from - to + 1)
    end
  end

  defp asc_r(b, n) do
    (n - 1)..0
    |> Enum.reduce([], fn val, coll ->
      [val + b | coll]
    end)
  end

  defp desc_r(b, n) do
    (n - 1)..0
    |> Enum.reduce([], fn val, coll ->
      [b - val | coll]
    end)
  end

  def rotate(times, notes) do
    len = notes |> Enum.count()
    n = (rem(times, len) + len) |> rem(len)
    Enum.slice(notes, n, len) ++ Enum.slice(notes, 0, n)
  end

  def compact(arr) when is_list(arr) do
    arr |> Enum.filter(&(!!&1))
  end

  def shuffle(array) do
    shuffle(array, fn -> :rand.uniform() end)
  end

  def shuffle(array, rand) do
    m = Enum.count(array) - 1

    Enum.reduce(m..0, array, fn val, coll ->
      i = floor(rand.() * val)
      t = coll |> Enum.at(val)

      coll
      |> List.replace_at(val, Enum.at(coll, i))
      |> List.replace_at(i, t)
    end)
  end

  def permutations([]), do: [[]]

  def permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h | t]
  end
end
