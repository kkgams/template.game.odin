// Objective-C compilation unit only; platform callbacks and rendering are Odin.
#define IMPL
#define SOKOL_METAL
// Clear each unit's implementation macro before glue re-includes app/gfx
// declarations; otherwise a combined translation unit defines them twice.
#include "../../vendor/sokol/c/sokol_app.c"
#undef SOKOL_APP_IMPL
#include "../../vendor/sokol/c/sokol_gfx.c"
#undef SOKOL_GFX_IMPL
#include "../../vendor/sokol/c/sokol_log.c"
#undef SOKOL_LOG_IMPL
#include "../../vendor/sokol/c/sokol_glue.c"
