defmodule MyCredoChecks.Consistency.DescribeArity do
  use Credo.Check, category: :consistency

  # TODO: Make it configurable through parameters
  @test_operations [:test, :test_with_params]
  @describe_regex ~r/^([\w|\!|\?]+)\/([0-9]+)/i

  def run(source_file, params \\ []) do
    ast = SourceFile.ast(source_file)
    issue_meta = IssueMeta.for(source_file, params)

    ast
    |> Credo.Code.prewalk(&traverse_describe/2)
    |> Enum.map(fn {meta, description, test} ->
      format_issue(
        issue_meta,
        message:
          "Test `#{test}` inside describe `#{description}` does not call its description function.",
        trigger: "#{test} inside #{description}",
        line_no: meta[:line]
      )
    end)
  end

  defp traverse_describe({:describe, _meta, [description, _block]} = ast, acc) do
    new_issues =
      if parsed_description = parse_description(description) do
        ast
        |> Credo.Code.prewalk(&traverse_test(&1, &2, parsed_description))
        |> Enum.map(fn {meta, test} -> {meta, description, test} end)
      else
        []
      end

    {ast, new_issues ++ acc}
  end

  defp traverse_describe(ast, acc) do
    {ast, acc}
  end

  defp traverse_test({operation, meta, block} = ast, issues, {name, arity})
       when operation in @test_operations do
    calls =
      block
      |> Credo.Code.prewalk(&traverse_calls/2)
      # Strips module name (for now). TODO: Consider module names
      |> Enum.map(fn {_, name, arity} -> {name, to_string(arity)} end)

    if {name, arity} not in calls do
      {ast, [{meta, test_text(block)} | issues]}
    else
      {ast, issues}
    end
  end

  defp traverse_test(ast, issues, _text) do
    {ast, issues}
  end

  defp traverse_calls({:|>, _meta, block} = ast, acc) do
    {{target, _meta, arguments}, 0} = ast |> Macro.unpipe() |> List.last()
    {module, name} = piped_call_signature(target)
    call_signature = {module, name, length(arguments) + 1}
    ast_without_current_call = List.delete_at(block, -1)

    {ast_without_current_call, [call_signature | acc]}
  end

  defp traverse_calls({{:., _, [{:__aliases__, _, _}, _]}, _, _} = ast, acc) do
    {ast, [call_signature(ast) | acc]}
  end

  defp traverse_calls(ast, acc) do
    {ast, acc}
  end

  defp parse_description(description) do
    case Regex.run(@describe_regex, description) do
      [_, name, arity] -> {name, arity}
      _ -> nil
    end
  end

  defp piped_call_signature({:., _, [{:__aliases__, _, mod_list}, fun]}) do
    module = Credo.Code.Name.last(mod_list)
    name = Credo.Code.Name.full(fun)

    {module, name}
  end

  defp piped_call_signature(fun) when is_atom(fun) do
    name = Credo.Code.Name.full(fun)

    {nil, name}
  end

  defp call_signature({{:., _, [{:__aliases__, _, mod_list}, fun]}, _, arguments}) do
    module = Credo.Code.Name.last(mod_list)
    name = Credo.Code.Name.full(fun)

    {module, name, length(arguments)}
  end

  defp test_text([text | _]) when is_binary(text), do: text
  defp test_text(_), do: ""
end
