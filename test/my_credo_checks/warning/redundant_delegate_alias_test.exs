defmodule MyCredoChecks.Warning.RedundantDelegateAliasTest do
  use Credo.Test.Case

  describe "ok" do
    test "not redundant" do
      """
      defmodule Module do
        defdelegate func_name(arg_1, arg_2, arg_3), to: OtherModule, as: :func_name_2
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Warning.RedundantDelegateAlias)
      |> refute_issues()
    end
  end

  describe "issues" do
    test "redundant alias" do
      """
      defmodule Module do
        defdelegate func_name(arg_1, arg_2, arg_3), to: OtherModule, as: :func_name
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Warning.RedundantDelegateAlias)
      |> assert_issue()
    end
  end
end
