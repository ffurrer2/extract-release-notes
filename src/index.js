// SPDX-License-Identifier: MIT
const core = require('@actions/core')
const fs = require('fs')
const readline = require('readline')
const esrever = require('esrever');

const encoding = 'utf8'
const eol = '\n'
const topEmptyLines = new RegExp("^([" + eol + "]*)", "m");

main().catch(err => core.setFailed(err.message))

async function main() {
    const changelogFile = core.getInput('changelog_file', {required: true})
    core.debug(`changelog-file = '${changelogFile}'`)

    const releaseNotesFile = core.getInput('release_notes_file')
    core.debug(`release-notes-file = '${releaseNotesFile}'`)

    const releaseNotes = await extractReleaseNotes(changelogFile)
    core.debug(`release-notes = '${releaseNotes}'`)

    writeReleaseNotesFile(releaseNotesFile, releaseNotes)

    core.setOutput("release_notes", releaseNotes)
}

async function extractReleaseNotes(changelogFile) {
    const fileStream = fs.createReadStream(changelogFile, {encoding: encoding})
    const rl = readline.createInterface({
        input: fileStream
    })
    const lines = []
    let inside_h2 = false
    for await (const line of rl) {
        const line_is_h2 = !!line.match("^## \\[[0-9]")
        if (inside_h2) {
            if (line_is_h2) {
                core.debug(`next h2 found: '${line}'`)
                break
            } else {
                lines.push(line)
                core.debug(`add line: '${line}'`)
            }
        } else {
            if (line_is_h2) {
                inside_h2 = true
                core.debug(`h2 found: '${line}'`)
            } else {
                core.debug(`skip line: '${line}'`)
            }
        }
    }
    let releaseNotes = lines.reduce((previousValue, currentValue) => previousValue + eol + currentValue)
    releaseNotes = trimEmptyLinesTop(releaseNotes)
    releaseNotes = trimEmptyLinesBottom(releaseNotes)
    return releaseNotes
}

function trimEmptyLinesTop(releaseNotes) {
    return releaseNotes.replace(topEmptyLines, '')
}

function trimEmptyLinesBottom(releaseNotes) {
    return esrever.reverse(trimEmptyLinesTop(esrever.reverse(releaseNotes)))
}

function writeReleaseNotesFile(releaseNotesFile, releaseNotes) {
    if (releaseNotesFile !== "") {
        core.debug(`writing release notes file: '${releaseNotesFile}'`)
        fs.writeFile(releaseNotesFile, releaseNotes, {encoding: encoding}, err => {
            if (err) {
                throw err
            }
        })
    }
}
