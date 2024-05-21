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

    const prerelease = core.getInput('prerelease')
    core.debug(`prerelease = '${prerelease}'`)

    const versionPrefix = core.getInput('version_prefix')
    core.debug(`version-prefix = '${versionPrefix}'`)

    const headerLevel = parseInt(core.getInput('header_level'))
    core.debug(`header_level = '${headerLevel}'`)

    const releaseNotes = await extractReleaseNotes(changelogFile, prerelease, versionPrefix, headerLevel)
    core.debug(`release-notes = '${releaseNotes}'`)

    writeReleaseNotesFile(releaseNotesFile, releaseNotes)

    core.setOutput("release_notes", releaseNotes)
}

async function extractReleaseNotes(changelogFile, prerelease, versionPrefix, headerLevel) {
    const fileStream = fs.createReadStream(changelogFile, {encoding: encoding})
    const rl = readline.createInterface({
        input: fileStream
    })
    const lines = []
    let inside_release = false
    const header_level = (Number.isInteger(headerLevel) && (headerLevel > 0) && (headerLevel < 7)) ? +headerLevel : 2
    const level_match_regex = "^#{" + header_level + "}\\s+"
    const levelup_match_regex = (header_level > 1) ? "^#{1," + (header_level - 1) + "}\\s+" : level_match_regex
    const version_match_regex = "\\[?" + escapeRegex(versionPrefix) + "\\s*[0-9]"
    const unreleases_match_regex = "\\[?Unreleased\\]?"
    core.debug(`version_match_regex: '${version_match_regex}'`)
    core.debug(`unrelease_match_regex: '${unreleases_match_regex}'`)
    for await (const line of rl) {
        let header_match = (!!line.match(level_match_regex))
        let headerup_match = (!!line.match(levelup_match_regex))
        let start_of_release = (!!line.match(level_match_regex + version_match_regex) || (prerelease === 'true' && !!line.match(level_match_regex + unreleases_match_regex)))
        if (inside_release) {
            if (header_match || headerup_match) {
                core.debug(`end of version block: '${line}'`)
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

function escapeRegex(string) {
    return string.replace(/[/\-\\^$*+?.()|[\]{}]/g, '\\$&');
}
