# SPDX-License-Identifier: MIT
FROM ffurrer/bats:latest

RUN apk --no-cache add gawk sed
RUN apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/latest-stable/community add docker-cli

WORKDIR /github/workspace
