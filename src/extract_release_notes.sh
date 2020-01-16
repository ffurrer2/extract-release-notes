#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
set -euo pipefail

extract_release_notes() {
  readonly changelog_file="${INPUT_CHANGELOG_FILE}"
  echo "::debug file=.github/actions/extract-release-notes/extract_release_notes.sh,line=6::using input variable: changelog_file=${changelog_file}"

  release_notes="$(awk '/^## \[[0-9]/ { flag=!flag; count+=1; next } flag && count < 2 {print}' "${changelog_file}" |
    sed '/./,$!d' |
    sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba')"

  if [[ -v INPUT_RELEASE_NOTES_FILE ]] && [[ -n ${INPUT_RELEASE_NOTES_FILE} ]]; then
    readonly release_notes_file="${INPUT_RELEASE_NOTES_FILE}"
    echo "::debug file=.github/actions/extract-release-notes/extract_release_notes.sh,line=14::using input variable: release_notes_file=${release_notes_file}"
    echo -n "${release_notes}" >"${release_notes_file}"
    echo "::debug file=.github/actions/extract-release-notes/extract_release_notes.sh,line=16::writing release notes file: ${release_notes_file}"
  fi

  release_notes="${release_notes//'%'/'%25'}"
  release_notes="${release_notes//$'\n'/'%0A'}"
  release_notes="${release_notes//$'\r'/'%0D'}"

  echo "::set-output name=release_notes::${release_notes}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  extract_release_notes "$@"
fi
