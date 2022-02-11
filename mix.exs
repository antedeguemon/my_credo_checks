defmodule AntedeguemonChecks.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :antedeguemon_checks,
      deps: deps(),
      description: "@antedeguemon's Credo checks",
      elixir: "~> 1.10",
      name: "AntedeguemonChecks",
      start_permanent: false,
      version: @version
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5"}
    ]
  end
end
