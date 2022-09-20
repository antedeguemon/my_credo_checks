defmodule MyCredoChecks.Readability.NoModuleTest do
  use Credo.Test.Case

  describe "ok" do
    test "alias" do
      """
      defmodule Module do
        defstruct [:name]
        alias __MODULE__

        @attribute Module
        def result, do: Module
        %Module{name: "Joe"}
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Readability.NoModule)
      |> refute_issues()
    end
  end

  describe "issues" do
    test "__MODULE__ struct" do
      """
      defmodule Module do
        defstruct [:name, :age]

        def build(name, age) do
          %__MODULE__{name: name, age: age}
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Readability.NoModule)
      |> assert_issue()
    end

    test "concatened call" do
      ~S(
      defmodule Module do
        def alias, do: "#{__MODULE__}"
      end
      )
      |> to_source_file()
      |> run_check(MyCredoChecks.Readability.NoModule)
      |> assert_issue()
    end

    test "multiline call" do
      """
      defmodule Module do
        def alias do
          work()
          __MODULE__
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Readability.NoModule)
      |> assert_issue()
    end

    test "inline call" do
      """
      defmodule Module do
        def alias, do: __MODULE__
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Readability.NoModule)
      |> assert_issue()
    end

    test "module attribute" do
      """
      defmodule Module do
        @attribute __MODULE__
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Readability.NoModule)
      |> assert_issue()
    end
  end
end
