#+build freestanding
package main

import "base:runtime"
import sg "../vendor/sokol/gfx"

// The only application-specific foreign ABI is the browser host, not graphics
// descriptors. sokol-odin calls the linked, vendored sg_* implementation directly.
foreign import browser "env"
@(default_calling_convention="c")
foreign browser {
	js_canvas_width :: proc() -> i32 ---
	js_canvas_height :: proc() -> i32 ---
	js_webgl_framebuffer :: proc() -> u32 ---
	game_log :: proc(level: u32, message: cstring, item: u32) ---
}

web_log :: proc "c" (tag: cstring, level, item: u32, message: cstring, line: u32, filename: cstring, user_data: rawptr) {
	context = runtime.default_context()
	game_log(level, message, item)
}

game_setup :: proc() {
	sg.setup({
		logger = {func = web_log},
		environment = {defaults = {color_format = .RGBA8, depth_format = .DEPTH_STENCIL, sample_count = 1}},
	})
}

game_swapchain :: proc() -> sg.Swapchain {
	return {
		width = js_canvas_width(), height = js_canvas_height(),
		color_format = .RGBA8, depth_format = .DEPTH_STENCIL, sample_count = 1,
		gl = {framebuffer = js_webgl_framebuffer()},
	}
}
