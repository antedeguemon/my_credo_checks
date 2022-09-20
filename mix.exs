defmodule MyCredoChecks.MixProject do
  use Mix.Project

  @version "0.1.3"

  def project do
    [
      app: :my_credo_checks,
      deps: deps(),
      description: "@antedeguemon's Credo checks",
      elixir: "~> 1.10",
      name: "MyCredoChecks",
      start_permanent: false,
      version: @version,
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6"}
    ]
  end

  defp package do
    [
      maintainers: ["antedeguemon"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/antedeguemon/my_credo_checks"}
    ]
  end
end
