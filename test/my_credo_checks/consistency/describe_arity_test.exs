defmodule MyCredoChecks.Consistency.DescribeArityTest do
  use Credo.Test.Case

  describe "function description" do
    test "ignores trailing comments" do
      """
      defmodule ModuleTest do
        describe "run/1 | some comment about run/2" do
          test "works" do
            Module.run(attrs)
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> refute_issues()
    end

    test "leading comment implies on not being a function description" do
      """
      defmodule ModuleTest do
        describe "this run/1" do
          test "works" do
            Module.not_run("hey", 1_234)
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> refute_issues()
    end

    test "not a function description" do
      """
      defmodule ModuleTest do
        describe "works 123" do
          test "not_a_describe/1" do
            attrs |> Module.function()
          end

          test "not a definition 123" do
            attrs |> Module.function()
          end
        end

        test "works/1" do
          attrs |> Module.function()
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> refute_issues()
    end
  end

  describe "ok" do
    test "function is called without pipe" do
      """
      defmodule ModuleTest do
        describe "function/2" do
          test ".." do
            attrs = %{}
            Module.function(attrs_1, attrs_2)
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> refute_issues()
    end

    test "function is called with a multiple pipe" do
      """
      defmodule ModuleTest do
        describe "fun/3" do
          test "works" do
            attrs
            |> OtherModule.fun_1()
            |> Module.fun(:argument, :other)
            |> OtherModule.fun_2()
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> refute_issues()
    end

    test "function is called with an inline pipe" do
      """
      defmodule ModuleTest do
        describe "fun/3" do
          test "works" do
            attrs |> OtherModule.fun_1() |> Module.fun(:argument, :other) |> OtherModule.fun_2()
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> refute_issues()
    end

    test "function is called with pipe for local function" do
      """
      defmodule ModuleTest do
        describe "fun/3" do
          test "works" do
            attrs |> fun(1, 2)
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
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
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
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
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
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
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> assert_issue()
    end

    test "arity minus one through a pipe" do
      """
      defmodule ModuleTest do
        describe "function/2" do
          test ".." do
            1 |> run_1() |> Module.function() |> run_2()
          end
        end
      end
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> assert_issue()
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> assert_issue()
    end

    test "arity plus one through a pipe" do
      """
      defmodule ModuleTest do
        describe "function/1" do
          test "works" do
            1 |> run_1() |> Module.function(:second_argument) |> run_2()
          end
        end
      end
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> assert_issue()
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Consistency.DescribeArity)
      |> assert_issue()
    end
  end
end
