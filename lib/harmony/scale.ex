defmodule Harmony.Scale do
  alias Harmony.Scale.Name
  alias __MODULE__
  defmodule do

  end

  def get([t, s]) when is_list(src) do
    tonic = note(t).name
    st = Name.get(s)

    if st.empty do
      %Scale{}
    else
      type = st.name

      notes =
        if tonic
          Enum.map st.intervals, &transpose(tonic, &1)
        else
          []
        end

      name =
        if tonic
          "#{tonic} #{type}"
        else
          type
        end

      %Scale{st | name: name, type: type, tonic: tonic, notes: notes }
    end
  end

  def get(src) do
    src |> tmokenize() |> get()
  end
end
