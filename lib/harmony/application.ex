defmodule Harmony.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Harmony.Scale.Name, nil},
      {Harmony.Chord.Name, nil}
    ]

    opts = [strategy: :one_for_one, name: Harmony.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
