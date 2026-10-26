// Compile the official vendored implementation with our freestanding GL/libc
// adapters. All setup, resources, pipelines and draw orchestration live in Odin.
#define SOKOL_GLES3
#define SOKOL_EXTERNAL_GL_LOADER
#include <GLES3/gl3.h>
#include <gl_funcs.h>

#define IMPL
#include "../../vendor/sokol/c/sokol_gfx.c"
