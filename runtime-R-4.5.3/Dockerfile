
FROM rockylinux/rockylinux:8.10 AS builder

RUN dnf install -y epel-release && dnf clean all

RUN dnf install -y shadow-utils; \
    mkdir -p "/app"; \
    groupadd --gid 1000 app; \
    useradd --uid 1000 --gid 1000 \
            --home-dir "/app" --create-home \
            --shell /usr/sbin/nologin \
            app; \
    chown -R app:app "/app"; \
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
        glibc-langpack-en \
        bash \
        coreutils-single \
    && dnf --installroot /mnt/rootfs clean all \
    && rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/* \
              /mnt/rootfs/usr/share/doc/* /mnt/rootfs/usr/share/man/*;

RUN install -D -m 0644 -o root -g root /etc/passwd /mnt/rootfs/etc/passwd; \
    install -D -m 0644 -o root -g root /etc/group  /mnt/rootfs/etc/group; \
    cp -r /app /mnt/rootfs/;

RUN mkdir -p /mnt/rootfs/tmp /mnt/rootfs/scripts && \
    chmod 1777 /mnt/rootfs/tmp

FROM scratch
COPY --from=builder /mnt/rootfs/ /

#
#
#
ARG APP_HOME=/app
ARG APP_R_HOME=.R
ARG APP_R_LIBRARY=4.5/library
ARG R_LIBS_USER=${APP_HOME}/${APP_R_HOME}/${APP_R_LIBRARY}
ARG R_CRAN_MIRROR="https://cloud.r-project.org"
ENV R_CRAN_MIRROR=${R_CRAN_MIRROR}
RUN mkdir -p "${R_LIBS_USER}" && \
    chown -R app:app "${APP_HOME}/${APP_R_HOME}" && \
    printf 'R_LIBS_USER=%s\n' "${R_LIBS_USER}" >> "$(R RHOME)/etc/Renviron.site"; \
    printf 'R_CRAN_MIRROR=%s\n' "${R_CRAN_MIRROR}" >> "$(R RHOME)/etc/Renviron.site"; \
    cat "$(R RHOME)/etc/Renviron.site"; \
    printf 'options(repos = c(CRAN = Sys.getenv("R_CRAN_MIRROR")))\n' \
        >> "$(R RHOME)/etc/Rprofile.site"; \
    cat "$(R RHOME)/etc/Rprofile.site";

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

USER app
WORKDIR /app
ENTRYPOINT ["R"]
CMD [""]

# Lib Paths:
# /app/.R/4.5/library
# /usr/lib64/R/library
# /usr/share/R/library
