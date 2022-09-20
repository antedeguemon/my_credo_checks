defmodule MyCredoChecks.Warning.DuplicatedAlias do
  use Credo.Check, category: :warning, base_priority: :high

  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    modules = Credo.Code.prewalk(source_file, &traverse(&1, &2), [])

    modules
    |> Enum.group_by(fn {module, _meta} -> module end, fn {_module, meta} -> meta end)
    |> Enum.flat_map(fn
      {_module, [_meta]} ->
        []

      {module, [_ | metas]} ->
        Enum.map(metas, fn meta ->
          format_issue(issue_meta,
            message: "Duplicated alias #{module}",
            trigger: module,
            line_no: meta[:line]
          )
        end)
    end)
    |> Enum.reject(&(&1 == []))
  end

  defp traverse(
         {:alias, meta, [{:__aliases__, _, _module}, [as: {:__aliases__, _me, as_module}]]} = ast,
         acc
       ) do
    as_module = Credo.Code.Name.last(as_module)

    {ast, [{as_module, meta} | acc]}
  end

  defp traverse({:alias, meta, [{:__aliases__, _, module} | _alias_opts]} = ast, acc) do
    module = Credo.Code.Name.last(module)

    {ast, [{module, meta} | acc]}
  end

  defp traverse(ast, acc) do
    {ast, acc}
  end
end
