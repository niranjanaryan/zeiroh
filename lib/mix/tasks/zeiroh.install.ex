defmodule Mix.Tasks.Zeiroh.Install do
  @moduledoc "Build escript and install `zeiroh` for Linux, macOS, and Windows."
  use Mix.Task
  @shortdoc "Install the zeiroh CLI (all OS)"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")
    Mix.Task.run("escript.build")

    dest = Zeiroh.CLI.Paths.install_escript("zeiroh")
    Mix.shell().info("installed #{dest}")
    Mix.shell().info(path_hint())
  end

  defp path_hint do
    dir = Zeiroh.CLI.Paths.bin_dir()

    if Zeiroh.CLI.Paths.windows?() do
      "add #{dir} to PATH (Windows: System Properties → Environment Variables)"
    else
      "ensure #{dir} is on PATH"
    end
  end
end
