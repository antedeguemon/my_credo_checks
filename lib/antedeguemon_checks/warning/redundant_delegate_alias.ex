defmodule AntedeguemonChecks.Warning.RedundantDelegateAlias do
  use Credo.Check

  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  defp traverse({:defdelegate, meta, [source, target]} = ast, issues, issue_meta) do
    {source_function_name, _, _} = source
    target_function_name = Keyword.get(target, :as)

    if source_function_name == target_function_name do
      {ast, [issue_for(target_function_name, meta, issue_meta) | issues]}
    else
      {ast, issues}
    end
  end

  defp traverse(ast, issues, _) do
    {ast, issues}
  end

  defp issue_for(trigger, meta, issue_meta) do
    format_issue(
      issue_meta,
      message: "Redundant defdelegate to #{to_string(trigger)}.",
      trigger: to_string(trigger),
      line_no: meta[:line]
    )
  end
end
