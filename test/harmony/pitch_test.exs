defmodule Harmony.PitchTest do
  use ExUnit.Case

  alias Harmony.Pitch

  @c %Pitch{step: 0, alt: 0}
  @cs %Pitch{step: 0, alt: 1}
  @cb %Pitch{step: 0, alt: -1}
  @a %Pitch{step: 5, alt: 0}

  # Notes
  @c4 %Pitch{step: 0, alt: 0, oct: 4}
  @a4 %Pitch{step: 5, alt: 0, oct: 4}
  @gs6 %Pitch{step: 4, alt: 1, oct: 6}

  # Intervals
  @p5 %Pitch{step: 4, alt: 0, oct: 0, dir: 1}
  @p_5 %Pitch{step: 4, alt: 0, oct: 0, dir: -1}

  test "height" do
    assert [-1200, -1199, -1201, -1191] = Enum.map([@c, @cs, @cb, @a], &Pitch.height(&1))
    assert [48, 57, 80] = Enum.map([@c4, @a4, @gs6], &Pitch.height(&1))
    assert [7, -7] = Enum.map([@p5, @p_5], &Pitch.height(&1))
  end

  test "midi" do
    assert [nil, nil, nil, nil] = Enum.map([@c, @cs, @cb, @a], &Pitch.midi(&1))
    assert [60, 69, 92] = Enum.map([@c4, @a4, @gs6], &Pitch.midi(&1))
  end

  test "chroma" do
    assert [0, 1, 11, 9] = Enum.map([@c, @cs, @cb, @a], &Pitch.chroma(&1))
    assert [0, 9, 8] = Enum.map([@c4, @a4, @gs6], &Pitch.chroma(&1))
    assert [7, 7] = Enum.map([@p5, @p_5], &Pitch.chroma(&1))
  end

  test "coordinates" do
    assert [0] = Pitch.coordinates(@c)
    assert [3] = Pitch.coordinates(@a)
    assert [7] = Pitch.coordinates(@cs)
    assert [-7] = Pitch.coordinates(@cb)

    # notes
    assert [0, 4] = Pitch.coordinates(@c4)
    assert [3, 3] = Pitch.coordinates(@a4)

    # intervals
    assert [1, 0] = Pitch.coordinates(@p5)
    assert [-1, -0] = Pitch.coordinates(@p_5)
  end

  test "pitch" do
    assert @c = Pitch.get([0])
    assert @cs = Pitch.get([7])
  end
end
