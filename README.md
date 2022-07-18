<!-- SPDX-License-Identifier: MIT -->

# Extract Release Notes

[![CI](https://github.com/ffurrer2/extract-release-notes/workflows/CI/badge.svg)](https://github.com/ffurrer2/extract-release-notes/actions?query=workflow%3ACI)
[![MIT License](https://img.shields.io/github/license/ffurrer2/extract-release-notes)](https://github.com/ffurrer2/extract-release-notes/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/ffurrer2/extract-release-notes?sort=semver)](https://github.com/ffurrer2/extract-release-notes/releases/latest)

This GitHub Action extracts release notes from a [Keep a Changelog](https://keepachangelog.com/) formatted changelog file.

## Usage

### Prerequisites

- Create a `CHANGELOG.md` file based on the changelog format of the [Keep a Changelog](https://keepachangelog.com/) project.
- Create a workflow `.yml` file in your `.github/workflows` directory. An [example workflow](#example-workflow---create-a-release-with-release-notes) is available below. For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

| Input                             | Description                                                   |
| --------------------------------- | ------------------------------------------------------------- |
| `changelog_file` _(optional)_     | The input path of the changelog file. Default: `CHANGELOG.md` |
| `release_notes_file` _(optional)_ | The output path of the (optional) release notes file.         |

### Outputs

| Output          | Description                |
| --------------- | -------------------------- |
| `release_notes` | The escaped release notes. |

### Example workflow - create a release with release notes

On every `push` to a tag matching the pattern `*.*.*`, extract the release notes from the `CHANGELOG.md` file and [create a release](https://github.com/actions/create-release):

```yaml
name: Create Release

on:
  push:
    tags:
      - '*.*.*'

jobs:
  build:
    name: Create release
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Extract release notes
        id: extract-release-notes
        uses: ffurrer2/extract-release-notes@v1
      - name: Create release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: ${{ github.ref }}
          draft: false
          prerelease: false
          body: ${{ steps.extract-release-notes.outputs.release_notes }}
```

This will extract the content between the second and third H2 header from the `CHANGELOG.md` file, store this content in the output variable `release_notes` and create a [release](https://help.github.com/en/articles/creating-releases) using the official [create-release](https://github.com/actions/create-release) action.

This uses the `GITHUB_TOKEN` provided by the [virtual environment](https://help.github.com/en/github/automating-your-workflow-with-github-actions/virtual-environments-for-github-actions#github_token-secret), so no new token is needed.

## Examples

### Use a dedicated changelog file

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Extract release notes
        id: extract-release-notes
        uses: ffurrer2/extract-release-notes@v1
        with:
          changelog_file: MY_CHANGELOG.md
```

### Create a release notes file

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Extract release notes
        uses: ffurrer2/extract-release-notes@v1
        with:
          release_notes_file: RELEASE_NOTES.md
```

### Extract prerelease notes

To extract the content between the first (`## [Unreleased]`) and second H2 header, set the `prerelease` parameter to `true`.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Extract release notes
        uses: ffurrer2/extract-release-notes@v1
        with:
          prerelease: true
```

## License

The scripts and documentation in this project are released under the [MIT License](LICENSE).
