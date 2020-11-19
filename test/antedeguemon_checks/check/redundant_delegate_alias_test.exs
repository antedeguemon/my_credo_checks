defmodule AntedeguemonChecks.Check.Warning.RedundantDelegateAliasTest do
  use Credo.Test.Case

  @described_check AntedeguemonChecks.Check.Warning.RedundantDelegateAlias

  test "when a defdelegate has a redundant alias" do
    """
    defmodule Module do
      defdelegate func_name(arg_1, arg_2, arg_3), to: OtherModule, as: :func_name
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "when a defdelegate is not redundant" do
    """
    defmodule Module do
      defdelegate func_name(arg_1, arg_2, arg_3), to: OtherModule, as: :func_name_2
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> refute_issues()
  end
end
