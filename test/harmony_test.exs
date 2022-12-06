defmodule HarmonyTest do
  use ExUnit.Case
  doctest Harmony

  test "greets the world" do
    assert Harmony.hello() == :world
  end
end
