defmodule Mix.Tasks.Zeiroh.Install do
  @moduledoc "Build escript and install `zeiroh` to ~/.local/bin."
  use Mix.Task
  @shortdoc "Install the zeiroh CLI"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")
    Mix.Task.run("escript.build")

    bin_dir = Path.expand("~/.local/bin")
    File.mkdir_p!(bin_dir)

    escript = Path.join(File.cwd!(), "zeiroh")
    File.cp!(escript, Path.join(bin_dir, "zeiroh"))
    File.chmod!(Path.join(bin_dir, "zeiroh"), 0o755)

    Mix.shell().info("installed #{Path.join(bin_dir, "zeiroh")}")
    Mix.shell().info("ensure #{bin_dir} is on PATH")
  end
end
