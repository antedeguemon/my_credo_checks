defmodule AntedeguemonChecks.Check.Warning.RejectTagsTest do
  use Credo.Test.Case

  @described_check AntedeguemonChecks.Check.Warning.RejectTags

  test "when there is no violation" do
    """
    defmodule Module.Tag do
      @moduleattr :hey
      @attribute "okay"

      def tag do
        :moduletag
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "when there is a tag module attribute" do
    """
    defmodule Module do
      @tag :test
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "when there is a describetag module attribute" do
    """
    defmodule Module do
      @describetag :test
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "when there is a moduletag module attribute" do
    """
    defmodule Module do
      @moduletag :test
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issue()
  end
end
