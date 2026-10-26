# Vendored sokol-odin

Source: https://github.com/floooh/sokol-odin
Snapshot: `132fa9d26acf98cf6358a61e8baadf985196ab42` (2026-09-14).
Its paired Sokol headers correspond to upstream Sokol
`5ee4b0b381e747884fdcf50c062369afc66c4f54`.

This is the **app, gfx, glue and log subset**, with matching `c/` implementation
inputs, `LICENSE` and `UPSTREAM-README.md`. Other packages, examples and binary
archives are intentionally omitted. C sources/headers are unmodified. Notices
inside both headers and generated bindings are retained. Upstream bindings keep
terminal blank lines; `.gitattributes` exempts only their blank-at-EOF whitespace
check rather than reformatting these third-party files.

## Local binding adaptation

Each of the four generated `.odin` bindings has one clearly marked extra branch
before its original platform link selection:

- `SOKOL_CUSTOM_BUILD=true` selects archives/objects in the `sokol-build` Odin
  collection, supplied by Make as the absolute `build.nosync/` directory.
- Native uses `native-support.a`; WASM uses `web-support.o`.
- All foreign declarations, types, enum values and original link branches are
  untouched. No custom graphics descriptor ABI replaces the official bindings.

`scripts/sokol-link-config.py` applies this exact adaptation to newly downloaded
bindings and fails on an unexpected upstream link block. It does not silently
rewrite existing files. Binary outputs never belong beside the bindings.

## Dependency policy

The tracked files themselves are the snapshot. There is no lock/checksum/update
layer. `make sokol` downloads **only missing** source files; normal builds leave
existing files/edits untouched. `SOKOL_URL` defaults to the upstream `main/sokol`
raw URL and overrides downloads only. For exact restoration of this snapshot:

```sh
make sokol SOKOL_URL=https://raw.githubusercontent.com/floooh/sokol-odin/132fa9d26acf98cf6358a61e8baadf985196ab42/sokol
```

To refresh, remove the desired files, rebuild and review the diff. Bindings and
C headers must stay from the same compatible revision; partial updates or a
new upstream API can break layouts or builds. Check native and actual browser
rendering after changes. Revision names here are provenance, not an
automatic dependency resolver.
