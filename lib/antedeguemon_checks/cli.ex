defmodule AntedeguemonChecks.CLI do
  @cwd File.cwd!()

  def main(argv) do
    argv_with_config_file = argv ++ ["--config-file", credo_file()]

    Credo.CLI.main(argv_with_config_file)
  end

  defp credo_file, do: Path.join(@cwd, ".credo.exs")
end
