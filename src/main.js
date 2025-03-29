// SPDX-License-Identifier: MIT
import * as core from '@actions/core'
import * as extract from './extract.js'

export async function run() {
  try {
    const changelogFile = core.getInput('changelog_file', { required: true })
    core.debug(`changelog-file = '${changelogFile}'`)

    const releaseNotesFile = core.getInput('release_notes_file')
    core.debug(`release-notes-file = '${releaseNotesFile}'`)

    const prerelease = core.getInput('prerelease')
    core.debug(`prerelease = '${prerelease}'`)

    const releaseNotes = await extract.extractReleaseNotes(
      changelogFile,
      prerelease
    )
    core.debug(`release-notes = '${releaseNotes}'`)

    await extract.writeReleaseNotesFile(releaseNotesFile, releaseNotes)

    core.setOutput('release_notes', releaseNotes)
  } catch (error) {
    if (error instanceof Error) core.setFailed(error.message)
  }
}
