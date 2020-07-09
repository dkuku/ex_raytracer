defmodule Raytracer.MixProject do
  use Mix.Project

  def project do
    [
      app: :raytracer_challenge,
      version: "0.1.0",
      elixir: "~> 1.11-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Raytracer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
       [{:git_hooks, "~> 0.5.0", only: [:test, :dev], runtime: false}]
  end
end
