defmodule AntedeguemonChecks.Warning.DuplicatedAliasTest do
  use Credo.Test.Case

  describe "ok" do
    test "no duplicated aliases" do
      """
      defmodule Module do
        alias My.Module, as: MyModule
        alias Module

        use Module
        use MyModule

        import Module
        import MyModule

        @attribute_1 Module
        @attribute_2 MyModule

        def name_1, do: Module
        def name_2, do: MyModule
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.DuplicatedAlias)
      |> refute_issues()
    end

    test "repeated alias is aliased" do
      """
      defmodule Module do
        alias Project.Query, as: ProjectQuery
        alias Ecto.Query
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.DuplicatedAlias)
      |> refute_issues()
    end
  end

  describe "issues" do
    test "exact duplicated alias" do
      """
      defmodule Module do
        alias Ecto.Query
        alias Ecto.Query
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.DuplicatedAlias)
      |> assert_issue()
    end

    test "multiple alias with same suffix" do
      """
      defmodule Module do
        alias Project.Query
        alias Ecto.Query
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.DuplicatedAlias)
      |> assert_issue()
    end

    test "duplicated alias has :as option" do
      """
      defmodule Module do
        alias Ecto.Query, as: Query
        alias Query
      end
      """
      |> to_source_file()
      |> run_check(AntedeguemonChecks.Warning.DuplicatedAlias)
      |> assert_issue()
    end
  end
end
