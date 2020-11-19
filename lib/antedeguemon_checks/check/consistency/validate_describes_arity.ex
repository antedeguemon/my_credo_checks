defmodule AntedeguemonChecks.Check.Consistency.ValidateDescribesArity do
  use Credo.Check

  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  defp traverse({:describe, _meta, [text, _block]} = ast, issues, issue_meta) do
    if function_description?(text) do
      describe_issues = Credo.Code.prewalk(ast, &traverse_test(&1, &2, text, issue_meta))

      {ast, describe_issues ++ issues}
    else
      {ast, issues}
    end
  end

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end

  defp traverse_test({:test, meta, block} = ast, describe_issues, text, issue_meta) do
    if parse_description(text) in fetch_calls(block) do
      {ast, describe_issues}
    else
      {ast, [issue_for(test_text(block), text, meta, issue_meta) | describe_issues]}
    end
  end

  defp traverse_test(ast, describe_issues, _text, _issue_meta) do
    {ast, describe_issues}
  end

  defp function_description?(text) do
    String.match?(text, ~r/^(.*)\/[0-9]+/i)
  end

  defp issue_for(trigger_test, trigger_describe, meta, issue_meta) do
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

  defp parse_description(text) do
    [function_text, arity_text] = String.split(text, "/")
    {arity, _} = Integer.parse(arity_text)

    {function_text |> String.to_atom(), arity}
  end

  defp fetch_calls(block) do
    {_, symbol_table} = Macro.prewalk(block, [], &filter_calls/2)

    Enum.map(symbol_table, &remove_alias/1)
  end

  defp remove_alias({{:., _line, [{:__aliases__, _, module}, function]}, arity}) do
    {List.last(module), function, arity}
  end

  defp remove_alias(symbol), do: symbol

  defp filter_calls({symbol, _meta, block}, acc) when not is_nil(block) do
    {block, acc ++ [{symbol, Enum.count(block)}]}
  end

  defp filter_calls(ast, acc), do: {ast, acc}
end
