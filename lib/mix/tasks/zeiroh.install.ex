defmodule Mix.Tasks.Zeiroh.Install do
  @moduledoc "Install zeiroh: Burrito single binary if possible, else escript."
  use Mix.Task
  @shortdoc "Install the zeiroh CLI (single binary or escript)"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")

    case maybe_burrito() do
      {:ok, src} ->
        dest = Zeiroh.CLI.Paths.install_bin(src, "zeiroh")
        Mix.shell().info("installed single binary #{dest}")

      :error ->
        Mix.Task.run("escript.build")
        dest = Zeiroh.CLI.Paths.install_escript("zeiroh")
        Mix.shell().info("installed escript #{dest} (needs escript on PATH)")
        Mix.shell().info("for a single binary: zig 0.15 + xz, then mix zeiroh.binary")
    end

    Mix.shell().info("bin dir #{Zeiroh.CLI.Paths.bin_dir()}")
  end

  defp maybe_burrito do
    Mix.Task.run("zeiroh.binary")

    case Path.wildcard("burrito_out/zeiroh_*") do
      [f | _] -> {:ok, f}
      _ -> :error
    end
  rescue
    e ->
      Mix.shell().error("burrito: #{Exception.message(e)}")
      :error
  end
end
