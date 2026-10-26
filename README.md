# Game

Odin game development with Sokol, targeting **macOS/Metal** and **browser WebGL2**.
Both platforms share the same game code and shaders. The current scene draws an
RGB triangle on a black background.

## Run locally

Install Odin (dev-2026-09), Zig 0.17.0, Make, curl and Python 3. Native builds also
require macOS and the Xcode SDK. The shader compiler downloads on first build.
Web builds also require LLVM LLD's `wasm-ld` on `PATH`; Odin invokes it separately
from Zig. On Ubuntu, install it with `sudo apt-get install lld`.
No npm dependencies or Emscripten are required.

```sh
make play          # build web and serve http://127.0.0.1:8817
make run           # build and launch the native window
make web           # build build.nosync/web/
make native        # build build.nosync/game
make               # build both targets
```

Set `PORT=…` to change the web server port. Browser controls provide Pause/Resume
and Reload. Reload restarts the application with fresh WASM memory.

## Documentation

Run `make serve-docs` in another terminal alongside the game. Documentation is
served at http://localhost:8080; `DOCS_PORT=…` changes only the docs port.
Edit `docs/index.md` for the development guide. Run `make validate-docs` to check
its structure and links. The pinned wiki engine downloads on first use into
`build.nosync/`; validation requires Node.js 22+.

## Develop

Start in `game/main.odin`: `init()` creates rendering resources, `frame()` draws
the scene, and `cleanup()` shuts down Sokol. Keep game logic shared; platform
entrypoints handle graphics setup and swapchains. Callbacks entering Odin from
C or JavaScript establish `runtime.default_context()`.

| Path | Responsibility |
| --- | --- |
| `game/main.odin` | Shared game code and rendering |
| `game/main_native.odin` | Native entrypoint and Sokol App callbacks |
| `game/main_web.odin` | Browser imports and WebGL2 setup |
| `game/*.glsl` | Authored shaders |
| `game/*.glsl.odin` | Generated shader bindings; do not edit manually |
| `game/osx/`, `game/web/main.c` | Sokol implementation compilation units |
| `game/web/` | WebGL bridge and browser runner |
| `vendor/sokol/` | Odin bindings and matching Sokol C sources |

Edit shaders and rebuild normally, or run `make shaders`. The shader compiler
produces Metal and WebGL2 bindings beside each source using `-f sokol_odin`.
Keep both shader sources and generated modules in version control. Shader include
changes trigger regeneration automatically.

Odin owns game logic, rendering descriptors and final linking. Zig compiles only
Sokol's C implementation: a native archive or a WASM relocatable object. Make
supplies the `sokol-build` collection and `SOKOL_CUSTOM_BUILD` configuration to
link those outputs without putting binaries in vendor sources.

`make deps` downloads missing Sokol sources and shader tools without changing
existing files. To update a dependency, remove its local file, rebuild, and review
the resulting changes. Bindings and C sources must remain compatible. Download
sources can be overridden with `SOKOL_URL` and `SHDC_URL`; upstream versions may
introduce incompatible changes. Preserve third-party license notices.

Build output lives in `build.nosync/`, downloaded tools in `tools/`.
`make clean` removes build output while preserving tools and generated modules.
Inspect rendering in a real browser and on native Metal after graphics changes.

## Runtime limits

Freestanding Odin starts with a nil allocator. Before adding dynamic Odin
allocations, explicitly choose an allocator such as the runtime's WASM allocator.
The separate C allocator used by Sokol has a 1 MiB heap and does not reclaim
allocations; its `realloc` does not preserve existing data. Some GL bridge
operations are incomplete. Check these limits before adding allocations or new
rendering features.

## Editor

Open this directory in GAMS to use the Files/Code workspace configured in
`gams.json`. Standalone builds do not require GAMS or its installed Units.

## Publish web

The Pages workflow builds pushes to `release` and pull requests targeting
`release`. Deployment runs only for pushes or manual runs on `release`.
Enable **GitHub Actions** as the Pages source and allow `release` in the
`github-pages` environment.

Only `build.nosync/web/` is deployed. Relative asset URLs support hosting under a
repository subpath. Change `.github/workflows/pages.yml` if using another branch.
