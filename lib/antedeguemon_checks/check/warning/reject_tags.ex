defmodule AntedeguemonChecks.Check.Warning.RejectTags do
  use Credo.Check

  @forbidden_attributes [:describetag, :tag, :moduletag]

  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  defp traverse({:@, _, [{name, meta, _string}]} = ast, issues, issue_meta)
       when name in @forbidden_attributes do
    {ast, [issue_for(name, meta[:line], issue_meta) | issues]}
  end

  defp traverse(ast, issues, _) do
    {ast, issues}
  end

  defp issue_for(trigger, line_no, issue_meta) do
    format_issue(
      issue_meta,
      message: "There should be no @#{trigger}.",
      trigger: "@#{trigger}",
      line_no: line_no
    )
  end
end
