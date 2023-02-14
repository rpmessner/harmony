defmodule Harmony.CollectionTest do
  use ExUnit.Case, async: true

  alias Harmony.Collection, as: Subject

  test "range" do
    assert Subject.range(-2, 2) == [-2, -1, 0, 1, 2]
    assert Subject.range(2, -2) == [2, 1, 0, -1, -2]
  end

  test "rotate" do
    assert Subject.rotate(2, ~w(a b c d e)) == ~w(c d e a b)
  end

  test "compact" do
    input = ["a", 1, 0, true, false, nil]
    result = ["a", 1, 0, true]
    assert Subject.compact(input) == result
  end

  test "shuffle" do
    rnd = fn -> 0.2 end
    assert Subject.shuffle(~w(a b c d), rnd) == ["b", "c", "d", "a"]
  end

  test "permutations" do
    assert Subject.permutations(~w(a b c)) == [
             ["a", "b", "c"],
             ["a", "c", "b"],
             ["b", "a", "c"],
             ["b", "c", "a"],
             ["c", "a", "b"],
             ["c", "b", "a"]
           ]
  end
end
