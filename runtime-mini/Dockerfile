FROM rockylinux/rockylinux:8.9-minimal AS trimmed

RUN microdnf install -y epel-release;
RUN microdnf install -y \
      --setopt=install_weak_deps=0 \
      --setopt=tsflags=nodocs \
      --enablerepo=powertools \
      R-core; \
    microdnf install -y libuv; \
    microdnf remove epel-release; \
    microdnf clean all; \
    rm -rf /var/cache/dnf /var/log/dnf* /var/log/yum* /var/cache/yum;

RUN microdnf install -y \
      --setopt=install_weak_deps=0 \
      --setopt=tsflags=nodocs \
      shadow-utils; \
    curl -LO "https://download3.rstudio.org/centos8/x86_64/shiny-server-1.5.23.1030-x86_64.rpm"; \
    rpm -i "shiny-server-1.5.23.1030-x86_64.rpm"; \
    rm -f "shiny-server-1.5.23.1030-x86_64.rpm"; \
    microdnf remove shadow-utils; \
    microdnf remove libsemanage; \
    microdnf clean all; \
    rm -rf /var/cache/dnf /var/log/dnf* /var/log/yum* /var/cache/yum;

RUN rm -rf /opt/shiny-server/ext/node/bin/node; \
    rm -rf /opt/shiny-server/ext/node/include/; \
    rm -rf /opt/shiny-server/ext/node/lib/; \
    rm -f /opt/shiny-server/ext/node/*.md; \
    rm -f /opt/shiny-server/ext/node/LIC*; \
    rm -rf /opt/shiny-server/ext/node/share/; \
    rm -rf /opt/shiny-server/ext/pandoc/; \
    rm -rf /opt/shiny-server/python/; \
    rm -rf /opt/shiny-server/test/; \
    rm -rf /opt/shiny-server/manual.test; \
    rm -rf /opt/shiny-server/config/init.d/; \
    rm -rf /opt/shiny-server/config/systemd/; \
    rm -rf /opt/shiny-server/config/upstart/;

RUN microdnf install -y binutils; \
    find / -xdev -name '*.so*' -type f -exec strip --strip-unneeded {} \; 2>/dev/null; \
    strip --strip-all /opt/shiny-server/ext/node/bin/shiny-server; \
    strip --strip-all /usr/local/bin/pandoc; \
    microdnf remove -y binutils; \
    microdnf clean all; \
    rm -rf /var/cache/dnf /var/log/dnf* /var/log/yum* /var/cache/yum; \
    rm -rf /tmp/*;

RUN microdnf install -y findutils; \
    find /opt/shiny-server -type f \
         \( -iname 'npm' -o -iname 'npx' -o -iname 'corepack' \) \
     -exec rm -f {} +; \
    find /opt/shiny-server/node_modules -type d \
      \( -iname 'test' -o -iname 'tests' -o -iname '__tests__' \
         -o -iname 'doc' -o -iname 'docs' -o -iname 'example' -o -iname 'examples' \
         -o -iname '.github' -o -iname 'benchmark' -o -iname 'benchmarks' \) \
      -exec rm -rf {} +; \
    find /opt/shiny-server/node_modules -type f \
      \( -iname 'README*' -o -iname 'CHANGELOG*' -o -iname 'HISTORY*' \
         -o -iname 'CONTRIBUTING*' -o -iname 'AUTHORS*' -o -iname '*.md' \
         -o -iname '.travis.yml' -o -iname '.eslintrc*' -o -iname '.npmignore' \
         -o -iname '.editorconfig' -o -iname 'Makefile' \) \
      -delete; \
    microdnf remove -y findutils; \
    microdnf clean all; \
    rm -rf /var/cache/dnf /var/log/dnf* /var/log/yum* /var/cache/yum; \
    rm -rf /tmp/*;

RUN rm -rf /usr/games/;
RUN rm -rf /usr/include/;
RUN rm -rf /usr/local/;
RUN rm -rf /usr/src/;
RUN rm -rf /usr/tmp/;
RUN rm -rf /usr/share/doc/;
RUN rm -rf /usr/share/man/;
RUN rm -rf /usr/share/licenses/;
RUN rm -rf /usr/share/pki/;
RUN rm -rf /usr/sbin/;
RUN rm -rf /var/lib/dnf/;
RUN rm -rf /var/lib/rpm/;
RUN rm -rf /var/log/anaconda/;
RUN rm -rf /lost+found;
RUN rm -rf /media /mnt;
RUN rm -rf /var/adm /var/empty /var/games /var/gopher /var/kerberos /var/lock /var/mail /var/nis /var/preserve /var/spool /var/yp;
RUN rm -rf /var/ftp /var/db /var/ftp /var/local /var/opt /var/run;
RUN rm -rf /var/lib/games /var/lib/rpm-state /var/lib/shiny-server;
RUN rm -rf /home;
RUN rm -rf /lib/debug lib/games lib/rpm;

# Caution
RUN rm -rf /usr/share/misc/;
RUN rm -rf /usr/share/tcl8/;
RUN rm -rf /usr/share/tcl8.6/;
RUN rm -rf /usr/share/X11/;

# PREP
RUN mkdir -p /var/lib/shiny-server/; \
    chown shiny:shiny /var/lib/shiny-server/;

FROM localhost/builder:latest AS package_builder
RUN R -e "install.packages(c('shiny'), lib = '/usr/share/R/library')"
RUN R -e "install.packages(c('rmarkdown'), lib = '/usr/share/R/library')"

RUN Rscript -e 'cat(.libPaths(), sep="\n")' | while read -r libpath; do \
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

RUN Rscript -e 'cat(.libPaths(), sep="\n")' | while read -r libpath; do \
      [ -d "$libpath" ] || continue; \
      find "$libpath" -type f -name '*.so' -exec strip --strip-unneeded {} + 2>/dev/null; \
    done ; true

FROM scratch AS assembly
COPY --from=trimmed / /
COPY --from=package_builder /usr/share/R/library /usr/share/R/library

FROM scratch
COPY --from=assembly / /
USER shiny
