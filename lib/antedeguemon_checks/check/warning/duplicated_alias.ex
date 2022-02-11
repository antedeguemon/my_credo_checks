defmodule AntedeguemonChecks.Check.Warning.DuplicatedAlias do
  use Credo.Check

  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    aliases = Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
    duplicated_aliases = aliases -- Enum.uniq(aliases)

    Enum.map(duplicated_aliases, fn alias ->
      formatted_alias = Enum.join(alias, ".")

      format_issue(issue_meta,
        message: "Duplicated alias #{formatted_alias}",
        trigger: formatted_alias
      )
    end)
  end

  defp traverse({:alias, _meta, [{:__aliases__, _, module}]} = ast, acc, _issue_meta) do
    {ast, [module | acc]}
  end

  defp traverse(ast, issues, _), do: {ast, issues}
end
