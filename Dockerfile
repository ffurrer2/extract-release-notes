# SPDX-License-Identifier: MIT
# docker.io/library/alpine:3.12.0
FROM alpine@sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321

ARG BASH_VERSION=5.0.17-r0

RUN apk --no-cache add bash=${BASH_VERSION}

COPY src/extract_release_notes.sh /extract_release_notes.sh

ENTRYPOINT ["/extract_release_notes.sh"]
