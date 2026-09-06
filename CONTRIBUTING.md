# Contributing

## Setup

Elixir **1.17+**, OTP **27+**. No Zig NIF in this package.

```bash
mix deps.get
mix test
mix docs
```

Optional siblings (path deps when checked out next to this repo): `ingot`, `dusk`, `gale`, `crucible`.

## Scope

* `Zeiroh.FLAME.Iroh` / `Zenoh` / `Backend` — Phoenix FLAME backends
* Cluster launch that can stand alone or delegate to Ingot / Dusk
* Docs: EVAL.md, SCALING.md

Native Iroh/Zenoh NIFs live in Ingot and Dusk. Machine boot lives in Crucible.

## Hex

Maintainers: `mix hex.publish` from a clean `main` after `CHANGELOG.md` is
updated. See `PUBLISH.md`. Path deps are omitted when `HEX_PUBLISH=1`.
