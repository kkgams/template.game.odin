#+build !freestanding
package main

import sapp "../vendor/sokol/app"
import sg "../vendor/sokol/gfx"
import sglue "../vendor/sokol/glue"
import slog "../vendor/sokol/log"

game_setup :: proc() {
	sg.setup({environment = sglue.environment(), logger = {func = slog.func}})
}

game_swapchain :: proc() -> sg.Swapchain { return sglue.swapchain() }

main :: proc() {
	sapp.run({
		init_cb = init, frame_cb = frame, cleanup_cb = cleanup,
		width = 640, height = 480, window_title = "Game",
		icon = {sokol_default = true}, logger = {func = slog.func},
	})
}
