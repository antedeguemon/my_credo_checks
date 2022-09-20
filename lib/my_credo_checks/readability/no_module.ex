defmodule MyCredoChecks.Readability.NoModule do
  use Credo.Check, category: :readability, base_priority: :high

  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  defp traverse({:alias, _meta, [{:__MODULE__, _, _}]}, issues, _issue_meta) do
    {nil, issues}
  end

  defp traverse({:__MODULE__, meta, _} = ast, issues, issue_meta) do
    issue =
      format_issue(issue_meta,
        message:
          "__MODULE__ should not be referenced in the code. Use a __MODULE__ alias instead.",
        line_no: meta[:line]
      )

    updated_issues = [issue | issues]
    {ast, updated_issues}
  end

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end
end
