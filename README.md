# Zeiroh

[![Hex.pm](https://img.shields.io/hexpm/v/zeiroh.svg)](https://hex.pm/packages/zeiroh)
[![Hexdocs](https://img.shields.io/badge/hex-docs-purple.svg)](https://hexdocs.pm/zeiroh)
[![CI](https://github.com/niranjanaryan/zeiroh/actions/workflows/ci.yml/badge.svg)](https://github.com/niranjanaryan/zeiroh/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Sponsor](https://img.shields.io/badge/sponsor-GitHub-ea4aaa.svg)](https://github.com/sponsors/niranjanaryan)

Phoenix **FLAME** overlay for **Iroh** (iron) and **Zenoh**. First-class
package in this line, not a throwaway.

```
gale     — HTTP/3 (server + client)
ingot    — Iroh + Zenoh cluster / libcluster
dusk     — Zenoh-first cluster
orian    — BLAKE3 / S3 / S5 storage
zeiroh   — FLAME Iroh/Zenoh backends; launch ingot or dusk
crucible — boot the machine (local, docker, wrap Fly/K8s/EC2)
```

Zeiroh **runs** work (`FLAME.call`). Crucible **creates** the box. Ingot
or Dusk **join** nodes. Gale **talks** HTTP.

See **[EVAL.md](EVAL.md)** (honest limits) and **[SCALING.md](SCALING.md)**
(provisioner + overlay).

## Deps

```elixir
{:zeiroh, "~> 0.1"}
{:ingot, "~> 0.1", hex: :ingot_cluster, optional: true}
{:dusk, "~> 0.1", optional: true}        # Zenoh-first
{:gale, "~> 0.1", optional: true}        # HTTP
{:flame, "~> 0.5"}
```

Host still picks **one** of `iroh_beam` or `zenohex`.

## CLI

```bash
mix zeiroh.install          # ~/.local/bin/zeiroh

zeiroh backends
zeiroh flame --overlay both
zeiroh version
```

Inside a Mix project: `mix zeiroh backends`.

## Launch

```elixir
{Zeiroh, overlay: :both, live: false}
{Zeiroh, package: :ingot, iroh: true, zenoh: [live: false]}
{Zeiroh, package: :dusk, live: false}
```

## FLAME

```elixir
config :flame, :backend, {Zeiroh.FLAME.Backend,
  overlay: :both,           # :iroh | :zenoh | :both
  provisioner: :local}      # crucible: :docker | :fly | :k8s | :ec2
config :flame, :backend, {Zeiroh.FLAME.Iroh, alpns: ["zeiroh/flame"]}
config :flame, :backend, {Zeiroh.FLAME.Zenoh, connect: "tcp/127.0.0.1:7447"}
```

Today `remote_boot` is in-process unless a Crucible/Fly/K8s provisioner
is wired with `terminator_sup`. Overlay advertise still runs.

MIT.
