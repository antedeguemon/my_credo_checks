defmodule AntedeguemonChecks.Consistency.DescribeArityTest do
  use Credo.Test.Case

  describe "ok" do
    test "function is called without pipe" do
      """
      defmodule ModuleTest do
        describe "function/1" do
          test ".." do
            attrs = %{}
            Module.function(attrs)
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Consistency.DescribeArity)
      |> refute_issues()
    end

    @tag :skip
    test "function is called with pipe" do
      """
      defmodule ModuleTest do
        describe "function/1" do
          test ".." do
            attrs |> Module.function()
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Consistency.DescribeArity)
      |> refute_issues()
    end

    test "not a function description" do
      """
      defmodule ModuleTest do
        describe "works 123" do
          test ".." do
            attrs |> Module.function()
          end
        end

        test "works/1" do
          attrs |> Module.function()
        end
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Consistency.DescribeArity)
      |> refute_issues()
    end
  end

  describe "issues" do
    test "arity plus one" do
      """
      defmodule ModuleTest do
        describe "function/1" do
          test ".." do
            Module.function(2, 2)
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Consistency.DescribeArity)
      |> assert_issue()
    end

    test "arity minus one" do
      """
      defmodule ModuleTest do
        describe "function/2" do
          test ".." do
            Module.function(1)
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Consistency.DescribeArity)
      |> assert_issue()
    end

    test "described function not called" do
      """
      defmodule ModuleTest do
        describe "function/1" do
          test ".." do
            Module.other_function(2, 2)
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Consistency.DescribeArity)
      |> assert_issue()
    end
  end
end
