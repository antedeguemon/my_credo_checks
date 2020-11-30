defmodule AntedeguemonChecks.Check.Warning.UnspecifiedAsyncTestCase do
  use Credo.Check

  alias Credo.Code.Name

  def param_defaults do
    [excluded: []]
  end

  def run(source_file, params \\ []) do
    excluded_modules = Params.get(params, :excluded, __MODULE__)
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta, excluded_modules))
  end

  defp traverse({:use, meta, block} = ast, issues, issue_meta, excluded_modules) do
    if case?(block) and should_report?(block, excluded_modules) do
      use_opts = options(block)

      if use_opts |> Keyword.get(:async) |> is_nil() do
        {ast, [issue_for(meta, issue_meta) | issues]}
      else
        {ast, issues}
      end
    else
      {ast, issues}
    end
  end

  defp traverse(ast, issues, _, _) do
    {ast, issues}
  end

  defp case?([{:__aliases__, _meta, module} | _]) do
    module |> Name.last() |> String.contains?("Case")
  end

  defp should_report?([{:__aliases__, _meta, module} | _], excluded_modules) do
    use_name = Name.full(module)

    excluded_modules
    |> Enum.any?(fn excluded_module ->
      String.contains?(use_name, excluded_module |> to_string())
    end)
    |> Kernel.not()
  end

  defp options([{:__aliases__, _, _}, opts]), do: opts
  defp options(_), do: []

  defp issue_for(meta, issue_meta) do
    format_issue(
      issue_meta,
      message: "Test does not specify asyncness",
      trigger: nil,
      line_no: meta[:line]
    )
  end
end
