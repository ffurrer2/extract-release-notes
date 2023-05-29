<!-- SPDX-License-Identifier: MIT -->

# Extract Release Notes

[![CI](https://github.com/ffurrer2/extract-release-notes/workflows/CI/badge.svg)](https://github.com/ffurrer2/extract-release-notes/actions?query=workflow%3ACI)
[![MIT License](https://img.shields.io/github/license/ffurrer2/extract-release-notes)](LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/ffurrer2/extract-release-notes?sort=semver)](https://github.com/ffurrer2/extract-release-notes/releases/latest)

This GitHub Action extracts release notes from a [Keep a Changelog](https://keepachangelog.com/) formatted changelog file.

## Usage

### Prerequisites

- Create a `CHANGELOG.md` file based on the changelog format of the [Keep a Changelog](https://keepachangelog.com/) project.
- Create a workflow `.yml` file in your `.github/workflows` directory. An [example workflow](#example-workflow---create-a-release-with-release-notes) is available below. For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

| Input                             | Description                                                                                           |
| --------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `changelog_file` _(optional)_     | The input path of the changelog file. Default: `CHANGELOG.md`                                         |
| `release_notes_file` _(optional)_ | The output path of the (optional) release notes file.                                                 |
| `version_prefix` _(optional)_     | A prefix before the version number in the changelog header tag, e.g. `version` as in [version x.y.z]. |
| `header_level` _(optional)_       | The header level where the version description is expected. Default: `2`                              |

### Outputs

| Output          | Description                |
|-----------------|----------------------------|
| `release_notes` | The escaped release notes. |

### Example workflow - create a release with release notes

On every `push` to a tag matching the pattern `*.*.*`, extract the release notes from the `CHANGELOG.md` file and [create a release](https://help.github.com/en/articles/creating-releases):

```yaml
name: Create Release

on:
  push:
    tags:
      - '*.*.*'

jobs:
  release:
    name: Create release
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Extract release notes
        id: extract-release-notes
        uses: ffurrer2/extract-release-notes@v2
      - name: Create release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: gh release create ${{ github.ref_name }} --title ${{ github.ref_name }} --notes '${{ steps.extract-release-notes.outputs.release_notes }}'
```

This code will extract the content between the second and third H2 header from the `CHANGELOG.md` file, store this content in the output variable `release_notes` and create a release using the [`gh release create`](https://cli.github.com/manual/gh_release_create) command.

## Examples

### Use a dedicated changelog file

```yaml
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Extract release notes
        id: extract-release-notes
        uses: ffurrer2/extract-release-notes@v2
        with:
          changelog_file: MY_CHANGELOG.md
```

### Change expected version header level to H3

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
          header_level: 3
```

### Accept CHANGELOG.md files with [Version x.y.z] titles

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
          version_prefix: Version
```

### Create a release notes file

```yaml
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Extract release notes
        uses: ffurrer2/extract-release-notes@v2
        with:
          release_notes_file: RELEASE_NOTES.md
```

### Extract prerelease notes

To extract the content between the first (`## [Unreleased]`) and second H2 header, set the `prerelease` parameter to `true`.

```yaml
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Extract release notes
        uses: ffurrer2/extract-release-notes@v2
        with:
          prerelease: true
```

## License

This project is licensed under the [MIT License](LICENSE).
