# Publish Zeiroh to Hex.pm and GitHub

Canonical git remote: `https://github.com/niranjanaryan/zeiroh`

## Checklist

1. `mix test`
2. Version in `mix.exs` + `CHANGELOG.md`
3. `mix docs`
4. `HEX_PUBLISH=1 mix hex.build` — tarball must have no `_build/`, `deps/`, or path deps
5. `HEX_PUBLISH=1 mix hex.publish`
6. `git tag v0.1.0 && git push origin v0.1.0`
7. GitHub About: “Phoenix FLAME overlay for Iroh and Zenoh”
   Topics: `elixir`, `phoenix`, `flame`, `iroh`, `zenoh`, `libcluster`

Path Mix deps (`../ingot`, etc.) cannot ship on Hex. `HEX_PUBLISH=1` drops them;
hosts add `{:ingot, "~> 0.1", optional: true}` themselves.
