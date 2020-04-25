#!/usr/bin/env bats
# SPDX-License-Identifier: MIT

load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'
load '/opt/bats-file/load.bash'

readonly IMAGE=docker.pkg.github.com/ffurrer2/extract-release-notes/extract-release-notes:latest

@test "Docker build should work" {
    run docker build --pull --tag $IMAGE "$BATS_TEST_DIRNAME/../../"

    assert_success
}

@test "Docker container should include bash" {
    # shellcheck disable=SC2016
    run docker run \
                --rm \
                --entrypoint /bin/sh \
                "$IMAGE" \
                -c '[ -x "$(command -v bash)" ] || { echo "error: command not found: bash" >&2; exit 1; }'

    assert_success
}

@test "Docker container should include awk" {
    # shellcheck disable=SC2016
    run docker run \
                --rm \
                --entrypoint /bin/sh \
                "$IMAGE" \
                -c '[ -x "$(command -v awk)" ] || { echo "error: command not found: awk" >&2; exit 1; }'

    assert_success
}

@test "Docker container should include sed" {
    # shellcheck disable=SC2016
    run docker run \
                --rm \
                --entrypoint /bin/sh \
                "$IMAGE" \
                -c '[ -x "$(command -v sed)" ] || { echo "error: command not found: sed" >&2; exit 1; }'

    assert_success
}
