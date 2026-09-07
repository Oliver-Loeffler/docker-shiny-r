
FROM rockylinux/rockylinux:8.10 AS builder

RUN dnf install -y epel-release && dnf clean all

RUN dnf install -y shadow-utils binutils findutils; \
    mkdir -p "/app"; \
    groupadd --gid 1000 app; \
    useradd --uid 1000 --gid 1000 \
            --home-dir "/app" --create-home \
            --shell /usr/sbin/nologin \
            app;  \
    mkdir -p "/home/shiny"; \
    groupadd --gid 1001 shiny; \
    useradd --uid 1001 --gid 1001 \
            --home-dir "/home/shiny" --create-home \
            --shell /usr/sbin/nologin \
            shiny;  \
    chown -R shiny:shiny "/home/shiny"; \
    sudo usermod -a -G app shiny; \
    sudo usermod -a -G shiny app; \
    dnf clean all; \
    rm -rf /var/cache/dnf /var/log/dnf* /var/log/yum* /var/cache/yum;

RUN mkdir -p /mnt/rootfs && \
    dnf install \
        --installroot /mnt/rootfs \
        --releasever 8.10\
        --setopt install_weak_deps=0 \
        --setopt=tsflags=nodocs \
        --setopt reposdir=/etc/yum.repos.d \
        --setopt varsdir=/etc/dnf/vars \
        --nodocs -y \
        --enablerepo=powertools \
        R-core-4.5.3-1.el8 \
        glibc-minimal-langpack \
        bash \
        coreutils-single \
    && dnf --installroot /mnt/rootfs clean all \
    && rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/* \
              /mnt/rootfs/usr/share/doc/* /mnt/rootfs/usr/share/man/*;

RUN curl -LO "https://download3.rstudio.org/centos8/x86_64/shiny-server-1.5.23.1030-x86_64.rpm"; \
     dnf install \
          --installroot /mnt/rootfs \
          -y shiny-server-1.5.23.1030-x86_64.rpm \
  && dnf --installroot /mnt/rootfs clean all \
  && rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/* \
            /mnt/rootfs/usr/share/doc/* /mnt/rootfs/usr/share/man/* \
  && rm -rf /mnt/rootfs/opt/shiny-server/ext/pandoc/; \
     rm -rf /mnt/rootfs/opt/shiny-server/ext/node/bin/node; \
     rm -rf /mnt/rootfs/opt/shiny-server/ext/node/include/; \
     rm -rf /mnt/rootfs/opt/shiny-server/ext/node/lib/; \
     rm -f /mnt/rootfs/opt/shiny-server/ext/node/*.md; \
     rm -f /mnt/rootfs/opt/shiny-server/ext/node/LIC*; \
     rm -rf /mnt/rootfs/opt/shiny-server/ext/node/share/; \
     rm -rf /mnt/rootfs/mnt/rootfs/opt/shiny-server/python/; \
     rm -rf /mnt/rootfs/opt/shiny-server/test/; \
     rm -rf /mnt/rootfs/opt/shiny-server/manual.test; \
     rm -rf /mnt/rootfs/opt/shiny-server/config/init.d/; \
     rm -rf /mnt/rootfs/opt/shiny-server/config/systemd/; \
     rm -rf /mnt/rootfs/opt/shiny-server/config/upstart/; \
     strip --strip-all /mnt/rootfs/opt/shiny-server/ext/node/bin/shiny-server; \
     find /mnt/rootfs/opt/shiny-server/ -xdev -name '*.so*' -type f -exec strip --strip-unneeded {} \; 2>/dev/null;

ADD ./cleanup-shiny.sh /cleanup-shiny.sh
ADD cleanup-image.sh /cleanup-image.sh

ADD ./shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN mkdir -p /mnt/rootfs/var/lib/shiny-server/bookmarks \
 && chown -R app:app /mnt/rootfs/var/lib/shiny-server/bookmarks;


RUN install -D -m 0644 -o root -g root /etc/passwd /mnt/rootfs/etc/passwd; \
    install -D -m 0644 -o root -g root /etc/group  /mnt/rootfs/etc/group; \
    install -D -m 0644 -o root -g root /etc/shiny-server/shiny-server.conf \
                                       /mnt/rootfs/etc/shiny-server/shiny-server.conf;\
    cp -r /app /mnt/rootfs/; \
    chown -R app:app /mnt/rootfs/srv;

RUN mkdir -p /mnt/rootfs/tmp /mnt/rootfs/scripts && \
    chmod 1777 /mnt/rootfs/tmp

FROM scratch
COPY --from=builder /mnt/rootfs/ /

#
ARG APP_HOME=/app
ARG APP_R_HOME=.R
ARG APP_R_LIBRARY=4.5/library
ARG R_LIBS_USER=${APP_HOME}/${APP_R_HOME}/${APP_R_LIBRARY}
ARG SCRIPTS_USER=${APP_HOME}/.scripts/
ARG R_CRAN_MIRROR="https://cloud.r-project.org"
ENV R_CRAN_MIRROR=${R_CRAN_MIRROR} \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

#
#ADD cleanup-library.sh /app/.scripts/cleanup-library.sh
#ADD cleanup-symbols.sh /app/.scripts/cleanup-symbols.sh
#
RUN mkdir -p "${R_LIBS_USER}" "${SCRIPTS_USER}" "${APP_HOME}/server" "${APP_HOME}/logs" && \
    chown -R app:app "${SCRIPTS_USER}" && \
    chown -R app:app "${APP_HOME}/server" && \
    chown -R app:app "${APP_HOME}/logs" && \
    printf 'R_LIBS_USER=%s\n' "${R_LIBS_USER}" >> "$(R RHOME)/etc/Renviron.site"; \
    printf 'R_CRAN_MIRROR=%s\n' "${R_CRAN_MIRROR}" >> "$(R RHOME)/etc/Renviron.site"; \
    cat "$(R RHOME)/etc/Renviron.site"; \
    printf 'options(repos = c(CRAN = Sys.getenv("R_CRAN_MIRROR")))\n' \
        >> "$(R RHOME)/etc/Rprofile.site"; \
    cat "$(R RHOME)/etc/Rprofile.site";

USER app
WORKDIR /app
ENTRYPOINT ["/usr/bin/sh"]
# CMD [""]

# Lib Paths:
# /app/.R/4.5/library
# /usr/lib64/R/library
# /usr/share/R/library
