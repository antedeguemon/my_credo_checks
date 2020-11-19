defmodule AntedeguemonChecks.MixProject do
  use Mix.Project

  def project do
    [
      app: :antedeguemon_checks,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: false,
      deps: deps()
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
