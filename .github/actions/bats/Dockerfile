# SPDX-License-Identifier: MIT
FROM alpine:latest

ARG BATS_CORE_VERSION=1.1.0
ARG BATS_SUPPORT_VERSION=0.3.0
ARG BATS_ASSERT_VERSION=0.3.0
ARG BATS_FILE_VERSION=0.2.0

RUN apk --no-cache add bash gawk sed curl
RUN apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/latest-stable/community add docker-cli

WORKDIR /tmp
RUN curl -fsSLo bats_core.tgz https://github.com/bats-core/bats-core/archive/v${BATS_CORE_VERSION}.tar.gz && \
    mkdir -p bats_core && \
    tar xvf bats_core.tgz -C bats_core && \
    mv bats_core/bats-core-* /opt/bats-core && \
    ln -s /opt/bats-core/bin/bats /usr/sbin/bats && \
    rm -rf bats_core*

RUN curl -fsSLo bats_support.tgz https://github.com/ztombol/bats-support/archive/v${BATS_SUPPORT_VERSION}.tar.gz && \
    mkdir -p bats_support && \
    tar xvf bats_support.tgz -C bats_support && \
    mv bats_support/bats-support-* /opt/bats-support && \
    rm -rf bats_support*

RUN curl -fsSLo bats_assert.tgz https://github.com/ztombol/bats-assert/archive/v${BATS_ASSERT_VERSION}.tar.gz && \
    mkdir -p bats_assert && \
    tar xvf bats_assert.tgz -C bats_assert && \
    mv bats_assert/bats-assert-* /opt/bats-assert && \
    rm -rf bats_assert*

RUN curl -fsSLo bats_file.tgz https://github.com/ztombol/bats-file/archive/v${BATS_FILE_VERSION}.tar.gz && \
    mkdir -p bats_file && \
    tar xvf bats_file.tgz -C bats_file && \
    mv bats_file/bats-file-* /opt/bats-file && \
    rm -rf bats_file*

WORKDIR /github/workspace

ENTRYPOINT ["/usr/sbin/bats"]
