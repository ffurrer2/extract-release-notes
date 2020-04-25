#!/usr/bin/env bats
# SPDX-License-Identifier: MIT

load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'
load '/opt/bats-file/load.bash'

readonly PROFILE_SCRIPT="$BATS_TEST_DIRNAME/../../src/extract_release_notes.sh"

readonly TEST_RESOURCES_DIRNAME="$BATS_TEST_DIRNAME/../resources"
readonly TEST_CHANGELOG_FILE_1="$TEST_RESOURCES_DIRNAME/CHANGELOG_1.md"
readonly TEST_CHANGELOG_FILE_2="$TEST_RESOURCES_DIRNAME/CHANGELOG_2.md"
readonly TEST_CHANGELOG_FILE_3="$TEST_RESOURCES_DIRNAME/CHANGELOG_3.md"

readonly EXPECTED_OUTPUT_1='::set-output name=release_notes::### Added%0A%0A- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.%0A- At vero eos et accusam et justo duo dolores et ea rebum.%0A- Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.%0A- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.%0A- At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.%0A%0A### Changed%0A%0A- At vero eos et accusam et justo duo dolores et ea rebum.%0A- Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.%0A%0A### Removed%0A%0A- At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
readonly EXPECTED_OUTPUT_2='::set-output name=release_notes::### Added%0A%0A- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.%0A- At vero eos et accusam et justo duo dolores et ea rebum.%0A- Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.%0A- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.%0A- At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.%0A%0A### Changed%0A%0A- At vero eos et accusam et justo duo dolores et ea rebum.%0A- Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
readonly EXPECTED_OUTPUT_3='::set-output name=release_notes::### Added%0A%0A- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.'

readonly EXPECTED_RELEASE_NOTES_FILE_1=$(cat <<-EOF
### Added

- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.
- At vero eos et accusam et justo duo dolores et ea rebum.
- Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.
- At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

### Changed

- At vero eos et accusam et justo duo dolores et ea rebum.
- Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

### Removed

- At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
EOF
)

readonly EXPECTED_RELEASE_NOTES_FILE_2=$(cat <<-EOF
### Added

- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.
- At vero eos et accusam et justo duo dolores et ea rebum.
- Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.
- At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

### Changed

- At vero eos et accusam et justo duo dolores et ea rebum.
- Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
EOF
)

readonly EXPECTED_RELEASE_NOTES_FILE_3=$(cat <<-EOF
### Added

- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.
EOF
)

@test "profile_script should exist" {
    assert_file_exist "$PROFILE_SCRIPT"
}

@test "testdata should exist" {
  assert_file_exist "$TEST_CHANGELOG_FILE_1"
  assert_file_exist "$TEST_CHANGELOG_FILE_2"
  assert_file_exist "$TEST_CHANGELOG_FILE_3"
}

@test "extract_release_notes should print ::set-output message correctly, when changelog contains two releases" {
    export INPUT_CHANGELOG_FILE="$TEST_CHANGELOG_FILE_1"
    # shellcheck source=../../src/extract_release_notes.sh
    source "$PROFILE_SCRIPT"

    run extract_release_notes

    assert_success
    assert_output --partial "$EXPECTED_OUTPUT_1"

    unset INPUT_CHANGELOG_FILE
}

@test "extract_release_notes should print ::set-output message correctly, when changelog contains one release" {
    # shellcheck disable=SC2031,SC2030
    export INPUT_CHANGELOG_FILE="$TEST_CHANGELOG_FILE_2"
    # shellcheck source=../../src/extract_release_notes.sh
    source "$PROFILE_SCRIPT"

    run extract_release_notes

    assert_success
    assert_output --partial "$EXPECTED_OUTPUT_2"

    unset INPUT_CHANGELOG_FILE
}

@test "extract_release_notes should print ::set-output message correctly, when changelog contains one minimal release" {
    # shellcheck disable=SC2031,SC2030
    export INPUT_CHANGELOG_FILE="$TEST_CHANGELOG_FILE_3"
    # shellcheck source=../../src/extract_release_notes.sh
    source "$PROFILE_SCRIPT"

    run extract_release_notes

    assert_success
    assert_output --partial "$EXPECTED_OUTPUT_3"

    unset INPUT_CHANGELOG_FILE
}

@test "extract_release_notes should create release_notes_file correctly, when changelog contains two releases" {
    # shellcheck disable=SC2031,SC2030
    export INPUT_CHANGELOG_FILE="$TEST_CHANGELOG_FILE_1"
    INPUT_RELEASE_NOTES_FILE="$(mktemp)"
    export INPUT_RELEASE_NOTES_FILE
    # shellcheck source=../../src/extract_release_notes.sh
    source "$PROFILE_SCRIPT"

    run extract_release_notes

    assert_success
    assert_output --partial "$EXPECTED_OUTPUT_1"
    diff "$INPUT_RELEASE_NOTES_FILE" <(echo -n "$EXPECTED_RELEASE_NOTES_FILE_1")
    assert_success

    unset INPUT_CHANGELOG_FILE
    unset INPUT_RELEASE_NOTES_FILE
}

@test "extract_release_notes should create release_notes_file correctly, when changelog contains one release" {
    # shellcheck disable=SC2031,SC2030
    export INPUT_CHANGELOG_FILE="$TEST_CHANGELOG_FILE_2"
    INPUT_RELEASE_NOTES_FILE="$(mktemp)"
    export INPUT_RELEASE_NOTES_FILE
    # shellcheck source=../../src/extract_release_notes.sh
    source "$PROFILE_SCRIPT"

    run extract_release_notes

    assert_success
    assert_output --partial "$EXPECTED_OUTPUT_2"
    diff "$INPUT_RELEASE_NOTES_FILE" <(echo -n "$EXPECTED_RELEASE_NOTES_FILE_2")
    assert_success

    unset INPUT_CHANGELOG_FILE
    unset INPUT_RELEASE_NOTES_FILE
}

@test "extract_release_notes should create release_notes_file correctly, when changelog contains one minimal release" {
    # shellcheck disable=SC2031,SC2030
    export INPUT_CHANGELOG_FILE="$TEST_CHANGELOG_FILE_3"
    INPUT_RELEASE_NOTES_FILE="$(mktemp)"
    export INPUT_RELEASE_NOTES_FILE
    # shellcheck source=../../src/extract_release_notes.sh
    source "$PROFILE_SCRIPT"

    run extract_release_notes

    assert_success
    assert_output --partial "$EXPECTED_OUTPUT_3"
    diff "$INPUT_RELEASE_NOTES_FILE" <(echo -n "$EXPECTED_RELEASE_NOTES_FILE_3")
    assert_success

    unset INPUT_CHANGELOG_FILE
    unset INPUT_RELEASE_NOTES_FILE
}
