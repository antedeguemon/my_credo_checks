# antedeguemon_checks

This is a collection of my personal (and highly experimental) Credo checks.

## Installation

1. Install `antedeguemon_checks` as a dependency:

```elixir
def deps do
  [
    {:antedeguemon_checks, "~> 0.1.2"}
  ]
end
```

2. Add to your `.credo.exs` file:

```elixir
# ...
  checks: [
    {AntedeguemonChecks.Consistency.DescribeArity, []},
    {AntedeguemonChecks.Readability.NoModule, []},
    {AntedeguemonChecks.Warning.DuplicatedAlias, []},
    {AntedeguemonChecks.Warning.RedundantDelegateAlias, []},
    {AntedeguemonChecks.Warning.RejectTags, []},
    {AntedeguemonChecks.Warning.UnspecifiedAsync, []}
    # ...
  ]
```
