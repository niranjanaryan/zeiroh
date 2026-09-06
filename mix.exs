defmodule Zeiroh.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/niranjanaryan/zeiroh"

  def project do
    [
      app: :zeiroh,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: Zeiroh.CLI, name: "zeiroh"],
      docs: docs(),
      package: package(),
      description: description(),
      source_url: @source_url,
      homepage_url: "https://hex.pm/packages/zeiroh",
      name: "Zeiroh"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Zeiroh.Application, []}
    ]
  end

  defp deps do
    [
      {:telemetry, "~> 1.0"},
      {:libcluster, "~> 3.5", optional: true},
      {:flame, "~> 0.5", optional: true},
      {:ex_doc, "~> 0.38", only: :dev, runtime: false}
    ] ++ sibling(:ingot) ++ sibling(:dusk) ++ sibling(:gale) ++ sibling(:crucible)
  end

  # Path deps for local checkout; omitted from Hex tarball (path deps cannot ship).
  defp sibling(name) do
    path = Path.expand("../#{name}", __DIR__)

    if System.get_env("HEX_PUBLISH") != "1" and File.dir?(path) do
      [{name, path: path, optional: true}]
    else
      []
    end
  end

  defp description do
    "Phoenix FLAME overlay for Iroh and Zenoh. Launch Zeiroh, or cluster via Ingot / Dusk. Crucible boots machines."
  end

  defp docs do
    [
      main: "Zeiroh",
      source_url: @source_url,
      source_ref: "v#{@version}",
      extras: [
        "README.md",
        "EVAL.md",
        "SCALING.md",
        "CHANGELOG.md",
        "LICENSE",
        "FUNDING.md",
        "CONTRIBUTING.md",
        "SECURITY.md"
      ]
    ]
  end

  defp package do
    [
      name: "zeiroh",
      maintainers: ["Niranjan Aryan"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "#{@source_url}/blob/main/CHANGELOG.md",
        "Sponsor" => "https://github.com/sponsors/niranjanaryan",
        "HexDocs" => "https://hexdocs.pm/zeiroh",
        "Ingot" => "https://github.com/niranjanaryan/ingot",
        "Dusk" => "https://github.com/niranjanaryan/dusk",
        "Gale" => "https://github.com/niranjanaryan/gale",
        "Orian" => "https://github.com/niranjanaryan/orian"
      },
      files: ~w(
        lib mix.exs mix.lock README.md EVAL.md SCALING.md LICENSE CHANGELOG.md
        FUNDING.md CONTRIBUTING.md SECURITY.md CODE_OF_CONDUCT.md .formatter.exs
      )
    ]
  end
end
