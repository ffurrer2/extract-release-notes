// SPDX-License-Identifier: MIT
import * as core from '@actions/core'
import fs from 'fs'
import readline from 'readline'

const encoding = 'utf8'
const eol = '\n'
const topEmptyLines = new RegExp('^([' + eol + ']*)', 'm')

export async function extractReleaseNotes(changelogFile, prerelease) {
  const fileStream = fs.createReadStream(changelogFile, { encoding: encoding })
  const rl = readline.createInterface({
    input: fileStream
  })
  const lines = []
  let inside_release = false
  for await (const line of rl) {
    const start_of_release =
      !!line.match('^#+ \\[[vV]?[0-9]') || (prerelease === 'true' && !!line.match('^#+ \\[Unreleased\\]'))
    if (inside_release) {
      if (start_of_release) {
        core.debug(`next version found: '${line}'`)
        break
      } else {
        lines.push(line)
        core.debug(`add line: '${line}'`)
      }
    } else {
      if (start_of_release) {
        inside_release = true
        core.debug(`version found: '${line}'`)
      } else {
        core.debug(`skip line: '${line}'`)
      }
    }
  }
  let releaseNotes = lines.reduce((previousValue, currentValue) => previousValue + eol + currentValue, '')
  releaseNotes = trimEmptyLinesTop(releaseNotes)
  releaseNotes = trimEmptyLinesBottom(releaseNotes)
  return releaseNotes
}

function trimEmptyLinesTop(releaseNotes) {
  return releaseNotes.replace(topEmptyLines, '')
}

function trimEmptyLinesBottom(releaseNotes) {
  return reverse(trimEmptyLinesTop(reverse(releaseNotes)))
}

function reverse(str) {
  return Array.from(str).reverse().join('')
}

export async function writeReleaseNotesFile(releaseNotesFile, releaseNotes) {
  if (releaseNotesFile !== '') {
    core.debug(`writing release notes file: '${releaseNotesFile}'`)
    fs.writeFile(releaseNotesFile, releaseNotes, { encoding: encoding }, (err) => {
      if (err) {
        throw err
      }
    })
  }
}
