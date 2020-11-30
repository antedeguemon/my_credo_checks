# antedeguemon_checks

This is a colletion of my (highly experimental) Credo checks.

## Included checks

### 1. Consistency.ValidateDescribesArity

### 2. Warning.RedundantDelegateAlias

### 3. Warning.RejectTags

### 4. Warning.UnspecifiedAsyncnessTestCase

## Installing

### As a script

```
mix escript.build
mv antedeguemon_checks ~/bin
```

## As a library

Add to your `mix.exs`:
```elixir
{:antedeguemon_checks, "~> 0.1"}
```

And use the custom checks in your `.credo.exs` file:
```elixir
{AntedeguemonChecks.Check.Warning.RejectTags},
{AntedeguemonChecks.Check.Warning.RedundantDelegateAlias},
{AntedeguemonChecks.Check.Warning.UnspecifiedAsyncTestCase, [excluded: ["Credo.Test.Case"]]},
{AntedeguemonChecks.Check.Consistency.ValidateDescribesArity},
```
