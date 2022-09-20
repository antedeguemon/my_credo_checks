defmodule MyCredoChecks.Warning.RejectTagsTest do
  use Credo.Test.Case

  describe "ok" do
    test "no moduletag" do
      """
      defmodule Module.Tag do
        @moduleattr :hey
        @attribute "okay"
        def tag do
          :moduletag
        end
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Warning.RejectTags)
      |> refute_issues()
    end
  end

  describe "issues" do
    test "when tag module attribute" do
      """
      defmodule Module do
        @tag :skip
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Warning.RejectTags)
      |> assert_issue()
    end

    test "when describetag module attribute" do
      """
      defmodule Module do
        @describetag ":skip"
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Warning.RejectTags)
      |> assert_issue()
    end

    test "when moduletag module attribute" do
      """
      defmodule Module do
        @moduletag :skip
      end
      """
      |> to_source_file()
      |> run_check(MyCredoChecks.Warning.RejectTags)
      |> assert_issue()
    end
  end
end
