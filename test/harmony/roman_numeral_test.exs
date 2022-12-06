defmodule Harmony.RomanNumeralTest do
  alias Harmony.RomanNumeral
  alias Harmony.Interval

  use ExUnit.Case

  test "get" do
    assert %RomanNumeral{
             empty: false,
             name: "#VIIb5",
             roman: "VII",
             interval: "7A",
             acc: "#",
             chord_type: "b5",
             major: true,
             step: 6,
             alt: 1,
             oct: 0,
             dir: 1
           } = RomanNumeral.get("#VIIb5")
  end

  test "RomanNumeral is compatible with Pitch" do
    naturals = ~w(1P 2M 3M 4P 5P 6M 7M) |> Enum.map(&Interval.get/1)

    assert ~w(I II III IV V VI VII) =
             naturals
             |> Enum.map(&RomanNumeral.get/1)
             |> Enum.map(& &1.name)

    flats = ~w(1d 2m 3m 4d 5d 6m 7m) |> Enum.map(&Interval.get/1)

    assert ~w(bI bII bIII bIV bV bVI bVII) =
             flats
             |> Enum.map(&RomanNumeral.get/1)
             |> Enum.map(& &1.name)

    sharps = ~w(1A 2A 3A 4A 5A 6A 7A) |> Enum.map(&Interval.get/1)

    assert ~w(#I #II #III #IV #V #VI #VII) =
             sharps
             |> Enum.map(&RomanNumeral.get/1)
             |> Enum.map(& &1.name)
  end

  test "step" do
    decimal = fn x -> RomanNumeral.get(x).step end
    assert [0, 1, 2, 3, 4, 5, 6] = RomanNumeral.names() |> Enum.map(&decimal.(&1))
  end

  test "invalid" do
    assert "" = RomanNumeral.get("nothing").name
    assert "" = RomanNumeral.get("iI").name
  end

  test "roman" do
    assert "III" = RomanNumeral.get("IIIMaj7").roman
    names = RomanNumeral.names()
    assert ^names = RomanNumeral.names() |> Enum.map(&RomanNumeral.get(&1).name)
  end

  test "create from degrees" do
    names = RomanNumeral.names()
    assert ^names = 1..7 |> Enum.map(&RomanNumeral.get(&1 - 1).name)
  end

  test "names" do
    assert ~w(I II III IV V VI VII) = RomanNumeral.names()
    assert ~w(i ii iii iv v vi vii) = RomanNumeral.names(false)
  end
end
