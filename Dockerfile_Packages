FROM rockylinux/rockylinux:8.9-minimal AS builder

RUN microdnf install -y epel-release findutils;
RUN microdnf install -y \
      --setopt=install_weak_deps=0 \
      --setopt=tsflags=nodocs \
      --enablerepo=powertools \
      R; \
    microdnf install -y binutils; \
    microdnf clean all; \
    rm -rf /var/cache/dnf /var/log/dnf* /var/log/yum* /var/cache/yum;

RUN microdnf install -y cmake; \
    microdnf install -y gcc-toolset-12-gcc --enablerepo=powertools;

RUN microdnf install libuv libuv-devel --enablerepo=powertools -y;
RUN mkdir -p /usr/share/doc/R/html/;

RUN R_HOME=$(R RHOME) && \
    mkdir -p "${R_HOME}/etc" && \
    { \
      echo 'options(Ncpus = parallel::detectCores())'; \
    } >> "${R_HOME}/etc/Rprofile.site" && \
    { \
      echo 'MAKEFLAGS = -j$(nproc)'; \
    } >> "${R_HOME}/etc/Makevars.site";

RUN R_HOME=$(R RHOME) && \
    RPROFILE="${R_HOME}/etc/Rprofile.site" && \
    NEW_LINE='options(repos = c(CRAN = "https://cloud.r-project.org"))' && \
    if [ -f "$RPROFILE" ] && grep -q '^options(repos' "$RPROFILE"; then \
      sed -i "s|^options(repos.*|${NEW_LINE}|" "$RPROFILE"; \
    else \
      mkdir -p "$(dirname "$RPROFILE")" && echo "$NEW_LINE" >> "$RPROFILE"; \
    fi;

FROM scratch
COPY --from=builder / /

# /usr/lib64/R/library/

