#!/bin/bash
echo "Removing unwanted executables of Shiny Server"
rm -rf /mnt/rootfs/opt/shiny-server/ext/node/bin/node
rm -rf /mnt/rootfs/opt/shiny-server/ext/pandoc/

echo "Removing unwanted parts of Shiny Server"
rm -rf /mnt/rootfs/opt/shiny-server/ext/node/include/
rm -rf /mnt/rootfs/opt/shiny-server/ext/node/lib/
rm -f /mnt/rootfs/opt/shiny-server/ext/node/*.md
rm -f /mnt/rootfs/opt/shiny-server/ext/node/LIC*
rm -rf /mnt/rootfs/opt/shiny-server/ext/node/share/
rm -rf /mnt/rootfs/mnt/rootfs/opt/shiny-server/python/
rm -rf /mnt/rootfs/opt/shiny-server/test/
rm -rf /mnt/rootfs/opt/shiny-server/manual.test
rm -rf /mnt/rootfs/opt/shiny-server/config/init.d/
rm -rf /mnt/rootfs/opt/shiny-server/config/systemd/
rm -rf /mnt/rootfs/opt/shiny-server/config/upstart/
strip --strip-all /mnt/rootfs/opt/shiny-server/ext/node/bin/shiny-server;
find /mnt/rootfs/opt/shiny-server/ -xdev -name '*.so*' -type f -exec strip --strip-unneeded {} \; 2>/dev/null;

echo "Removing unwanted parts of Shiny Server Node components"
find /mnt/rootfs/opt/shiny-server -type f \
     \( -iname 'npm' -o -iname 'npx' -o -iname 'corepack' \) \
 -exec rm -f {} +; \
find /mnt/rootfs/opt/shiny-server/node_modules -type d \
  \( -iname 'test' -o -iname 'tests' -o -iname '__tests__' \
     -o -iname 'doc' -o -iname 'docs' -o -iname 'example' -o -iname 'examples' \
     -o -iname '.github' -o -iname 'benchmark' -o -iname 'benchmarks' \) \
  -exec rm -rf {} +; \
find /mnt/rootfs/opt/shiny-server/node_modules -type f \
  \( -iname 'README*' -o -iname 'CHANGELOG*' -o -iname 'HISTORY*' \
     -o -iname 'CONTRIBUTING*' -o -iname 'AUTHORS*' -o -iname '*.md' \
     -o -iname '.travis.yml' -o -iname '.eslintrc*' -o -iname '.npmignore' \
     -o -iname '.editorconfig' -o -iname 'Makefile' \) \
  -delete;