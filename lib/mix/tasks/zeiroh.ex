defmodule Mix.Tasks.Zeiroh do
  @moduledoc "Zeiroh CLI. Same as the `zeiroh` escript."
  use Mix.Task
  @shortdoc "zeiroh backends|flame"

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    Zeiroh.CLI.main(args, halt: false)
  end
end
