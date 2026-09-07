#!/bin/bash

echo "Removing unnecessary files from Package Library"

echo "/app/.R/4.5/library" | while read -r libpath; do \
     [ -d "$libpath" ] || continue; \
     find "$libpath" -mindepth 2 -maxdepth 2 -type d \
       \( -iname 'doc' -o -iname 'html' -o -iname 'help' \
          -o -iname 'vignettes' -o -iname 'tests' -o -iname 'include' \
          -o -iname 'unitTests' -o -iname 'testdata' -o -iname 'examples' \
          -o -iname 'demo' \) \
       -exec rm -rf {} + ; \
     find "$libpath" -mindepth 2 -type f -iname '*.pdf' -delete ; \
     find "$libpath" -mindepth 2 -maxdepth 2 -type f \
       \( -iname 'NEWS*' -o -iname 'CHANGELOG*' -o -iname 'ChangeLog*' \) \
       -delete ; \
    done
echo