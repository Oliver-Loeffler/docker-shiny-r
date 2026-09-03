FROM rockylinux/rockylinux:8.9-minimal AS trimmed

RUN microdnf install -y epel-release;
RUN microdnf install -y \
      --setopt=install_weak_deps=0 \
      --setopt=tsflags=nodocs \
      --enablerepo=powertools \
      R-core; \
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

# PREP
RUN mkdir -p /var/lib/shiny-server/; \
    chown shiny:shiny /var/lib/shiny-server/;

FROM localhost/builder:latest AS package_builder

RUN R -e "install.packages(c('shiny'), lib = '/usr/share/R/library')"
RUN R -e "install.packages(c('rmarkdown'), lib = '/usr/share/R/library')"

FROM scratch AS assembly

COPY --from=trimmed / /
COPY --from=package_builder /usr/share/R/library /usr/share/R/library

FROM scratch
COPY --from=assembly / /
USER shiny
