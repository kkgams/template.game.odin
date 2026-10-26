package main

import "base:runtime"
import sg "../vendor/sokol/gfx"

pipeline: sg.Pipeline
bindings: sg.Bindings

// C and JavaScript callbacks must establish Odin's runtime context.
@(export)
init :: proc "c" () {
	context = runtime.default_context()
	game_setup()
	vertices := [?]f32{
		 0.0,  0.5, 0.5, 1, 0, 0, 1,
		 0.5, -0.5, 0.5, 0, 1, 0, 1,
		-0.5, -0.5, 0.5, 0, 0, 1, 1,
	}
	bindings.vertex_buffers[0] = sg.make_buffer({
		data = {ptr = &vertices, size = size_of(vertices)},
	})
	shader := sg.make_shader(triangle_shader_desc(sg.query_backend()))
	pipeline = sg.make_pipeline({
		shader = shader,
		layout = {attrs = {
			ATTR_triangle_position = {format = .FLOAT3},
			ATTR_triangle_color0 = {format = .FLOAT4},
		}},
	})
	assert(sg.query_buffer_state(bindings.vertex_buffers[0]) == .VALID)
	assert(sg.query_shader_state(shader) == .VALID)
	assert(sg.query_pipeline_state(pipeline) == .VALID)
}

@(export)
frame :: proc "c" () {
	context = runtime.default_context()
	swapchain := game_swapchain()
	if swapchain.width == 0 || swapchain.height == 0 { return }
	sg.begin_pass({
		action = {colors = {0 = {load_action = .CLEAR, clear_value = {0, 0, 0, 1}}}},
		swapchain = swapchain,
	})
	sg.apply_pipeline(pipeline)
	sg.apply_bindings(bindings)
	sg.draw(0, 3, 1)
	sg.end_pass()
	sg.commit()
}

@(export)
cleanup :: proc "c" () {
	context = runtime.default_context()
	sg.shutdown()
	pipeline = {}
	bindings = {}
}
