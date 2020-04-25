#!/bin/bash
set -euo pipefail

entrypoint() {
    echo "::debug file=.github/actions/bats/docker-entrypoint.sh,line=5::installing awk and sed"
    apk --no-cache add gawk sed
    echo "::debug file=.github/actions/bats/docker-entrypoint.sh,line=7::installing docker-cli"
    apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/latest-stable/community add docker-cli
    echo "::debug file=.github/actions/bats/docker-entrypoint.sh,line=9::executing bats with the following args: '$*'"
    /usr/local/bin/bats "$@"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  entrypoint "$@"
fi
