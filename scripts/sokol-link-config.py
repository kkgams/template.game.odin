#!/usr/bin/env python3
"""Apply our only sokol-odin binding adaptation to a newly downloaded file.

Keep foreign declarations/layouts untouched. A build collection redirects the
upstream hardcoded archive paths into ignored build output, for both platforms.
"""
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
source = path.read_text()
module = path.name.removesuffix(".tmp").removesuffix(".odin")
old = "when ODIN_OS == .Windows {"
assert source.count(old) == 1, f"Unexpected upstream {module} link configuration"
new = f'''// Local adaptation: compile this vendored snapshot into the sokol-build collection.
when #config(SOKOL_CUSTOM_BUILD, false) {{
    when ODIN_ARCH == .wasm32 {{
        foreign import sokol_{module}_clib "sokol-build:web-support.o"
    }} else {{
        foreign import sokol_{module}_clib "sokol-build:native-support.a"
    }}
}} else when ODIN_OS == .Windows {{'''
path.write_text(source.replace(old, new))
