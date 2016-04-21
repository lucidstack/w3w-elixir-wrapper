defmodule What3words.Mixfile do
  use Mix.Project
  @version "1.0.0"

  def project do
    [app: :what3words,
     version: @version,
     elixir: "~> 1.2",
     description: "Wrapper for the What3Words API",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,

     # Docs
     name: "What3Words",
     docs: [source_ref: "v#{@version}", main: "What3Words",
            source_url: "https://github.com/lucidstack/w3w-elixir-wrapper"]
   ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp package do
    [maintainers: ["Andrea Rossi"],
     files: ["lib", "mix.exs", "README.md", "LICENSE"],
     licenses: ["MIT"],
     links: %{"Github" => "https://github.com/lucidstack/w3w-elixir-wrapper"}]
  end

  defp deps do
    [{:credo, "~> 0.3", only: [:dev, :test]},
     {:poison, "~> 2.1.0"},
     {:httpoison, "~> 0.8.3"},
     {:ex_doc, github: "elixir-lang/ex_doc", only: :dev},
     {:earmark, ">= 0.0.0", only: :dev}]
  end
end
