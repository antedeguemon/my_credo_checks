defmodule MyCredoChecks.MixProject do
  use Mix.Project

  @version "0.1.2"

  def project do
    [
      app: :my_credo_checks,
      deps: deps(),
      description: "@antedeguemon's Credo checks",
      elixir: "~> 1.10",
      name: "MyCredoChecks",
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
