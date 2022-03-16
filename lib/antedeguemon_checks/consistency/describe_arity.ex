defmodule AntedeguemonChecks.Consistency.DescribeArity do
  use Credo.Check, param_defaults: [ignored_functions: []]

  def run(source_file, params \\ []) do
    ast = SourceFile.ast(source_file)

    context = [
      issue_meta: IssueMeta.for(source_file, params),
      module_name: Credo.Code.Module.name(ast),
      ignored_functions: Keyword.get(params, :ignored_functions, [])
    ]

    Credo.Code.prewalk(ast, &traverse(&1, &2, context))
  end

  defp traverse({:describe, _meta, [text, _block]} = ast, issues, context) do
    if function_description?(text) do
      describe_issues =
        ast
        |> Macro.unpipe()
        |> Credo.Code.prewalk(&traverse_test(&1, &2, text, context))

      {ast, describe_issues ++ issues}
    else
      {ast, issues}
    end
  end

  defp traverse(ast, issues, _context) do
    {ast, issues}
  end

  defp traverse_test({:test, meta, block} = ast, issues, text, context) do
    {function_name, arity} = parse_test_description(text)

    if {function_name, arity} in fetch_calls(block) or
         function_name in context[:ignored_functions] do
      {ast, issues}
    else
      {ast, [issue_for(test_text(block), text, meta, context) | issues]}
    end
  end

  defp traverse_test(ast, issues, _text, _context) do
    {ast, issues}
  end

  defp function_description?(text) do
    String.match?(text, ~r/^(.*)\/[0-9]+/i)
  end

  defp issue_for(trigger_test, trigger_describe, meta, context) do
    issue_meta = context[:issue_meta]

    format_issue(
      issue_meta,
      message:
        "Test `#{trigger_test}` inside describe #{trigger_describe} does not call its description function.",
      trigger: "#{trigger_test} inside #{trigger_describe}",
      line_no: meta[:line]
    )
  end

  defp test_text([text | _]) when is_binary(text), do: text
  defp test_text(_), do: ""

  defp parse_test_description(text) do
    [function_text, arity_text | _] = String.split(text, "/")
    {arity, _} = Integer.parse(arity_text)

    {String.to_atom(function_text), arity}
  end

  defp fetch_calls(block) do
    {_, symbol_table} = Macro.prewalk(block, [], &filter_calls/2)

    Enum.map(symbol_table, &remove_alias/1)
  end

  defp filter_calls({symbol, _meta, block}, acc) when not is_nil(block) do
    {block, acc ++ [{symbol, Enum.count(block)}]}
  end

  defp filter_calls(ast, acc) do
    {ast, acc}
  end

  defp remove_alias({{:., _line, [{:__aliases__, _, _module}, function]}, arity}) do
    {function, arity}
  end

  defp remove_alias({symbol, arity}) do
    {symbol, arity}
  end
end
