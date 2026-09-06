defmodule Zeiroh.Cluster do
  @moduledoc """
  Starts Iroh and/or Zenoh overlay for FLAME runners.

  `:package` selects the cluster implementation:

  * `:zeiroh` (default) — local overlay processes
  * `:ingot` — `Ingot.Cluster` when the sibling dep is present
  * `:dusk` — `Dusk.Cluster` when the sibling dep is present
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  def child_spec(opts) do
    %{
      id: Keyword.get(opts, :name, __MODULE__),
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end

  @impl true
  def init(opts) do
    children =
      case Keyword.get(opts, :package, :zeiroh) do
        :ingot -> ingot_children(opts)
        :dusk -> dusk_children(opts)
        _ -> zeiroh_children(opts)
      end

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp ingot_children(opts) do
    if Code.ensure_loaded?(Ingot.Cluster) do
      [{Ingot.Cluster, Keyword.drop(opts, [:package, :name])}]
    else
      zeiroh_children(opts)
    end
  end

  defp dusk_children(opts) do
    if Code.ensure_loaded?(Dusk.Cluster) do
      [{Dusk.Cluster, Keyword.drop(opts, [:package, :name, :overlay])}]
    else
      zeiroh_children(Keyword.put(opts, :overlay, :zenoh))
    end
  end

  defp zeiroh_children(opts) do
    overlay = Keyword.get(opts, :overlay, :both)
    iroh? = overlay in [:iroh, :both, true]
    zenoh? = overlay in [:zenoh, :both, true]

    overlay_opts = Keyword.drop(opts, [:package, :name, :overlay, :iroh, :zenoh])

    []
    |> maybe_child(iroh?, {Zeiroh.Iroh, child_opts(opts, :iroh, overlay_opts)})
    |> maybe_child(zenoh?, {Zeiroh.Zenoh, child_opts(opts, :zenoh, overlay_opts)})
  end

  defp maybe_child(acc, false, _), do: acc
  defp maybe_child(acc, true, child), do: acc ++ [child]

  defp child_opts(opts, key, overlay_opts) do
    case Keyword.get(opts, key, overlay_opts) do
      true -> overlay_opts
      false -> overlay_opts
      list when is_list(list) -> Keyword.merge(overlay_opts, list)
      _ -> overlay_opts
    end
  end
end
