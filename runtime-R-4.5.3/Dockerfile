
FROM rockylinux/rockylinux:8.10 AS builder

RUN dnf install -y epel-release && dnf clean all
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
        R-core \
        glibc-langpack-en \
        bash \
        coreutils-single \
    && dnf --installroot /mnt/rootfs clean all \
    && rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/* \
              /mnt/rootfs/usr/share/doc/* /mnt/rootfs/usr/share/man/*

RUN mkdir -p /mnt/rootfs/tmp /mnt/rootfs/scripts && \
    chmod 1777 /mnt/rootfs/tmp

FROM scratch
COPY --from=builder /mnt/rootfs/ /

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

WORKDIR /scripts
ENTRYPOINT ["R"]
CMD [""]

# Lib Paths:
# /usr/lib64/R/library
# /usr/share/R/library