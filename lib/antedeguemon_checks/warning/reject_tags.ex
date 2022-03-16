defmodule AntedeguemonChecks.Warning.RejectTags do
  use Credo.Check,
    explanations: [
      check: """
      Modules should not have @tag, @describetag, and @moduletag attributes.

      ```elixir
        # Bad
        defmodule ModuleTest do
          @tag :wip
          test "..." do
        end
      ```
      """
    ],
    param_defaults: [forbidden_attributes: [:describetag, :tag, :moduletag]]

  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)
    forbidden_attributes = Params.get(params, :forbidden_attributes, __MODULE__)

    source_file
    |> Credo.Code.prewalk(&traverse(&1, &2))
    |> Enum.filter(fn {name, _line} -> name in forbidden_attributes end)
    |> Enum.map(fn {name, line} ->
      format_issue(name, line, issue_meta)
    end)
  end

  defp traverse({:@, _, [{name, meta, _string}]} = ast, acc) do
    {ast, [{name, meta[:line]} | acc]}
  end

  defp traverse(ast, acc) do
    {ast, acc}
  end

  defp format_issue(trigger, line_no, issue_meta) do
    format_issue(
      issue_meta,
      message: "There should be no @#{trigger}.",
      trigger: "@#{trigger}",
      line_no: line_no
    )
  end
end
