---
title: Game development
status: reference
---

# Game development

The game runs on macOS with Metal and in browsers with WebGL2. Both targets
compile the same Odin game code and shaders. The current scene draws an RGB triangle.

## Run the game and docs

Install Odin (dev-2026-09), Zig 0.17.0, Make, curl and Python 3. Native builds
require the Xcode macOS SDK. Web builds require LLVM LLD's `wasm-ld` on `PATH`
(`sudo apt-get install lld` on Ubuntu). Use Node.js 22+ for documentation validation.

Run these commands in separate terminals from the project root:

```sh
make play        # game: http://127.0.0.1:8817
make serve-docs  # docs: http://localhost:8080
```

Use `PORT=…` for the game server and `DOCS_PORT=…` for documentation.
To run natively, use `make run` instead of `make play`.

## Change the game

Start in `game/main.odin`. Create rendering resources in `init()`, draw in
`frame()`, and release resources in `cleanup()`. Native and browser graphics
setup live in `game/main_native.odin` and `game/main_web.odin`.

Keep game logic shared. Use the Sokol Odin bindings for graphics descriptors and
calls. Callbacks from C or JavaScript must establish Odin's runtime context.
Freestanding Odin has no default heap allocator; choose one explicitly before
adding dynamic allocations.

Edit `game/triangle.glsl` to change the shader. Rebuilding regenerates its Odin
module for Metal and WebGL2; do not edit the generated module directly.
Rebuild and reload the browser, or restart the native executable, after changes.

## Check changes

```sh
make web native     # compile both targets on macOS
make validate-docs  # check documentation structure and links
```

Inspect the game in a real browser and on native Metal after rendering changes.
