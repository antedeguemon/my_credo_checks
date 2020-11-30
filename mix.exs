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
      package: package(),
      start_permanent: false,
      version: @version,
      escript: escript()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5"},
      {:credo_naming, "~> 1.0"}
    ]
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/antedeguemon/antedeguemon_checks"}
    ]
  end

  defp escript do
    [main_module: AntedeguemonChecks.CLI]
  end
end
