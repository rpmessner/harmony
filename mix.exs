defmodule Harmony.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/ryanmessner/harmony"

  def project do
    [
      app: :harmony,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      dialyzer: dialyzer(),
      test_coverage: test_coverage(),
      name: "Harmony",
      source_url: @source_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Harmony.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.31", only: [:dev, :docs], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    A comprehensive music theory library for Elixir. Work with notes, intervals, chords,
    scales, and transposition. Elixir port of tonal.js with compile-time code generation.
    """
  end

  defp package do
    [
      name: "harmony",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Documentation" => "https://hexdocs.pm/harmony"
      },
      maintainers: ["Ryan Messner"],
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE CHANGELOG.md docs)
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: [
        "README.md",
        "CHANGELOG.md",
        "docs/getting-started.md",
        "docs/notes.md",
        "docs/intervals.md",
        "docs/transpose.md",
        "docs/chords.md",
        "docs/scales.md"
      ],
      groups_for_extras: [
        Guides: ~r/docs\/.*/
      ]
    ]
  end

  defp dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
      plt_add_apps: [:mix]
    ]
  end

  defp test_coverage do
    [
      summary: [threshold: 85],
      ignore_modules: [
        # Macro modules - generate code at compile time, not runtime testable
        Harmony.Note.Macros,
        Harmony.Interval.Macros,
        Harmony.RomanNumeral.Macros,
        Harmony.Pitch.ClassSet.Macros,
        # GenServer state modules - internal implementation details
        Harmony.Chord.Name.State,
        Harmony.Scale.Name.State
      ]
    ]
  end
end
