defmodule AntedeguemonChecks.Warning.UnspecifiedAsyncTest do
  use Credo.Test.Case

  describe "ok" do
    test "async specified" do
      """
      defmodule Module do
        use MyCase1, async: true
        use MyCase2, async: false
        use MyCase3, debug: true, async: true, verbose: true
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.UnspecifiedAsync)
      |> refute_issues()
    end

    test "async with other parameters in __using__" do
      """
      defmodule Module do
        use MyCase3, debug: true, async: true, verbose: true
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.UnspecifiedAsync)
      |> refute_issues()
    end

    test "not __using__ case" do
      """
      defmodule Module do
        import MyCase
        require MyCase
        alias MyCase
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.UnspecifiedAsync)
      |> refute_issues()
    end

    test "__using__ module not ending with case" do
      """
      defmodule Module do
        use ThisCanEndInCase.TestSupport
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.UnspecifiedAsync)
      |> refute_issues()
    end
  end

  describe "issues" do
    test "without async" do
      """
      defmodule Module do
        use MyCase
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.UnspecifiedAsync)
      |> assert_issue()
    end

    test "with other parameters but without async" do
      """
      defmodule Module do
        use MyCase, debug: true, verbose: false
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.UnspecifiedAsync)
      |> assert_issue()
    end

    test "longer module" do
      """
      defmodule Module do
        use TestSuit.Support.MyCase
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.UnspecifiedAsync)
      |> assert_issue()
    end
  end
end
