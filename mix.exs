defmodule Harpoon.MixProject do
  use Mix.Project

  def project do
    [
      app: :harpoon,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:tesla, "~> 1.3.0"},
      {:fisherman, github: "ironbay/fisherman", optional: true},
      {:jason, "~> 1.1", optional: true}
    ]
  end
end
