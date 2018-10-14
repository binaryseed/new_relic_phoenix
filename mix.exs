defmodule NewRelicPhoenix.MixProject do
  use Mix.Project

  def project do
    [
      app: :new_relic_phoenix,
      description: "New Relic Instrumentation adapter for Phoenix",
      version: "0.0.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      name: "New Relic Phoenix",
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NewRelicPhoenix.Application, []}
    ]
  end

  defp package do
    [
      maintainers: ["Vince Foley"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/binaryseed/new_relic_phoenix"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:phoenix, ">= 1.4.0-rc"},
      {:new_relic_agent, ">= 1.0.5"}
    ]
  end
end
