%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: []
      },
      strict: true,
      parse_timeout: 5000,
      color: true,
      checks: %{
        disabled: [
          # Many internal/macro modules don't need moduledoc
          {Credo.Check.Readability.ModuleDoc, []},
          # Predicate naming: keeping is_xxx for consistency with tonal.js port
          {Credo.Check.Readability.PredicateFunctionNames, []},
          # Macro-generated code uses parentheses in def for consistency
          {Credo.Check.Readability.ParenthesesOnZeroArityDefs, []},
          # Alias ordering - fix later
          {Credo.Check.Readability.AliasOrder, []}
        ]
      }
    }
  ]
}
