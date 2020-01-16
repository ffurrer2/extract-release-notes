# SPDX-License-Identifier: MIT
FROM bash:latest

WORKDIR /github/workspace

COPY src/extract_release_notes.sh /extract_release_notes.sh

ENTRYPOINT ["/extract_release_notes.sh"]
