#!/bin/bash
echo "Removing debug symbols from so files in Package Library"
echo "/app/.R/4.5/library" | while read -r libpath; do \
     [ -d "$libpath" ] || continue; \
     find "$libpath" -type f -name '*.so' -exec strip --strip-unneeded {} + 2>/dev/null; \
     done