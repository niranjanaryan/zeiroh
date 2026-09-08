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
      releases: releases(),
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
      {:ex_doc, "~> 0.38", only: :dev, runtime: false},
      {:burrito, "~> 1.6", optional: true, runtime: false}
    ] ++ sibling(:ingot_cluster) ++ sibling(:dusk) ++ sibling(:gale) ++ sibling(:crucible)
  end

  def wrap(%Mix.Release{} = release) do
    if Code.ensure_loaded?(Burrito), do: Burrito.wrap(release), else: release
  end

  defp releases do
    [
      zeiroh: [
        steps: [:assemble, &__MODULE__.wrap/1],
        burrito: [targets: burrito_targets()]
      ]
    ]
  end

  defp burrito_targets do
    [
      macos: [os: :darwin, cpu: :x86_64, skip_nifs: true],
      macos_silicon: [os: :darwin, cpu: :aarch64, skip_nifs: true],
      linux: [os: :linux, cpu: :x86_64, skip_nifs: true],
      linux_aarch64: [os: :linux, cpu: :aarch64, skip_nifs: true],
      windows: [os: :windows, cpu: :x86_64, skip_nifs: true]
    ]
  end

  # Path deps for local checkout; omitted from Hex tarball (path deps cannot ship).
  defp sibling(name) do
    path = Path.expand("../#{name}", __DIR__)

    if File.dir?(path) and not hex_publish?() do
      [{name, path: path, optional: true}]
    else
      []
    end
  end

  defp hex_publish? do
    System.get_env("HEX_PUBLISH") == "1"
  end

  defp description do
    "Phoenix FLAME overlay for Iroh and Zenoh. Launch Zeiroh, or cluster via IngotCluster / Dusk. Crucible boots machines."
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
        "IngotCluster" => "https://github.com/niranjanaryan/ingot_cluster",
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
