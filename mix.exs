defmodule SlUniqueIds.MixProject do
  use Mix.Project

  def project do
    [
      app: :sl_unique_ids,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        flags: [
          :error_handling,
          :race_conditions,
          :unmatched_returns
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.3", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:propcheck, "~> 1.1", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      check: ["credo --strict -a", "dialyzer"]
    ]
  end
end
