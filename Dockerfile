# SPDX-License-Identifier: MIT
FROM alpine:3.11.3

RUN apk --no-cache add bash

COPY LICENSE /LICENSE
COPY src/extract_release_notes.sh /extract_release_notes.sh

ENTRYPOINT ["/extract_release_notes.sh"]
