# my_credo_checks

This is a collection of my personal (and highly experimental) Credo checks.

## Installation

1. Install `my_credo_checks` as a dependency:

```elixir
def deps do
  [
    {:my_credo_checks, "~> 0.1.2"}
  ]
end
```

2. Add to your `.credo.exs` file:

```elixir
# ...
  checks: [
    {MyCredoChecks.Consistency.DescribeArity, []},
    {MyCredoChecks.Readability.NoModule, []},
    {MyCredoChecks.Warning.DuplicatedAlias, []},
    {MyCredoChecks.Warning.RedundantDelegateAlias, []},
    {MyCredoChecks.Warning.RejectTags, []},
    {MyCredoChecks.Warning.UnspecifiedAsync, []}
    # ...
  ]
```
