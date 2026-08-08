# RandomDayGuard

> [!IMPORTANT]
> ## Project status — RandomDay testing concluded
>
> The RandomDay test operation is complete, and the public test server will close soon.
>
> During this operation, RandomDay and RandomDayGuard ran together through repeated profile rotations, normal and interrupted server restarts, recovery and rollback checks, extended-mod integration, server-evidence collection, and operator-report review.
>
> This gave us the knowledge we set out to gain: how rotating sandbox profiles behave throughout real dedicated-server lifecycles; how RandomDay interacts with supported extended mods; and how far RandomDayGuard can turn the evidence written by the server into useful, cautious monitoring without presenting gaps or guesses as facts.
>
> **Test-server stack used:**
>
> - RandomDay private development build `v0.41.76`
> - RandomDayGuard private development build `v0.46.130`
> - Chaotic Spawn Engine / DynamicSpawns `0.8.5 Hotfix 1`
> - Lethal Lasers `1.0 UE4SS`
> - ANTE Up `0.26`
> - Encounter Director integration — a RandomDay-owned DynamicSpawns extension, not a separately distributed mod
> - UE4SS `v3.0.1 Beta #0` (Git `01e0a584`; Nexus `v3.0.1-940-g01e0a584`)
> - Abiotic Factor dedicated server `1.4.0.27939`
>
> The currently published packages remain RandomDay `v0.3.16-alpha` and RandomDayGuard `v0.4.12-alpha`.
>
> Development of both projects is now paused. The existing releases and documentation will remain available, and we may return when we once again feel the pull to continue the work.
>
> This stack documents what was used during the operation; it is not a minimum-version requirement or a guarantee of compatibility with later game, loader, or mod versions. The final formally recorded cycle used Abiotic Factor `1.4.0.27939`.

<img width="2022" height="778" alt="RandomDayGuard cover" src="https://github.com/user-attachments/assets/d25915ec-1120-4620-9865-ebf3b422eaf8" />

RandomDayGuard reads records already produced by an Abiotic Factor dedicated
server and turns them into reports an operator can act on. It keeps server
health, the daily history, player sessions, review cases, and Guard failures in
separate reports so one channel does not repeat everything.

**Current release:** `v0.4.12-alpha`

This is an alpha release. Its named collection, reporting, recovery, and
review paths are tested, while compatibility, historical coverage, and report
quality continue to be improved. Keep normal server backups and review the
current report coverage before relying on a conclusion.

**Languages:** [Choose one of 27 reading paths](docs/locales/LANGUAGES.md)

## What the five reports answer

| Report | Question it answers | Typical contents |
| --- | --- | --- |
| **Server status** | Is Guard completing current monitoring cycles, and what server context can it read now? | Scheduler state, current run start when available, latest completed cycle, connected-player count, active/rotated log counts, scan progress, source gaps, and one next step. |
| **Daily rollup** | What does the available record say about this report date? | Same-day joins and leaves, session outcomes, connected players, current review subjects, retained identity/case context, source coverage, and explicit gaps. It is written once per report date. |
| **Player activity** | Which supported same-day player sessions changed? | Account and display name when known, join and leave times, clean or incomplete exit, lifecycle context, source references, and the next review step. Nothing is sent when no player activity exists. |
| **Case review** | Which named account has current review material? | Current status, score, identity strength, observed time bounds when known, warning/reason context, source references, unknowns, and a review action. Nothing is sent when no current case exists. |
| **Critical Guard** | Has Guard itself failed in a way that needs attention? | The current startup, poll, or report failure, its effect on monitoring, cited current-boot records, and a recovery action. Routine cautions do not belong here. |

[See complete report examples](docs/REPORT_EXAMPLES.md)

## What a useful report looks like

A report does not merely say that files exist. It reads the available values,
organizes them for its one purpose, and states what is known, what remains
unknown, and what to do next.

For example, a player-activity report can say that account
`76561198000000400` joined at 10:02, left normally at 11:18, reconnected twice
within ten minutes, and had no earlier cases in the seven-day history. A daily
rollup can say that the server was online for 23 hours 47 minutes, restarted
twice, completed six of seven player sessions normally, verified 23 backups,
and could not read the 04:00 backup log. The numbers come from the server
records used for that report; they are not filler text.

## Current facts first, older history in the background

Guard has two evidence paths. The current path starts with information already
available now: the active game log, current startup and scheduler state, current
sessions, and existing current reports. This path can produce server status and
new activity reports while the server is running.

The historical path works through retained logs, PlayerData filenames, existing
evidence and cases, and other configured source groups in bounded steps. Its
progress survives later cycles, but a large archive can take time. If its cursor
and last-progress time stop changing across repeated checks, the historical
scan is stalled: current reports can still be valid, while claims that require
complete older history remain limited until the scan resumes.

[Read the first result and scan state](docs/START_HERE.md)

## Install and read the first result

1. Download the current RandomDayGuard release.
2. Follow [Install RandomDayGuard](INSTALL.md).
3. Keep the default watch-and-report behavior for the first run.
4. Follow [Start here](docs/START_HERE.md) until the server-status report names
   the scheduler state, current run start when available, latest completed
   cycle, log and scan coverage, source gaps, and any required action.

## Watch first; choose actions later

A new installation reads available records and writes reports. It does not edit
the server ban list.

Ban-list editing is an optional advanced feature. If you decide to use it,
[Admin.ini enforcement](docs/ADMIN_INI_ENFORCEMENT.md) explains the accepted
account identity, protected moderator and trusted accounts, configured review
threshold, backup, change detection, saved-result check, and restoration path.
If any required safety check fails, Guard leaves the ban list unchanged and
records why.

## Help and project links

**Install and operate RandomDayGuard**

- [Documentation home](docs/README.md)
- [Installation, updates, and removal](INSTALL.md)
- [First report](docs/START_HERE.md)
- [Report examples](docs/REPORT_EXAMPLES.md)
- [Operations playbook](docs/OPERATIONS_PLAYBOOK.md)
- [Player review](docs/PLAYER_REVIEW_WORKFLOW.md)
- [Configuration](docs/CONFIG_PROFILES.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

**Downloads and updates**

- [RandomDayGuard on Nexus Mods](https://www.nexusmods.com/abioticfactor/mods/215)
- [RandomDayGuard source repository](https://github.com/Xixicor/RandomDay-Guard)
- [Changelog](CHANGELOG.md)

**Other Olmteka Studio mod**

- [RandomDay on Nexus Mods](https://www.nexusmods.com/abioticfactor/mods/212)
- [RandomDay source repository](https://github.com/Xixicor/RandomDay-Mod)

**Studio and media**

- [Olmteka Studio](https://studio.olmteka.com/)
- [Featured project video](https://www.youtube.com/watch?v=1HsnSpSSl80)

**Project policies and credits**

- [Contributing](CONTRIBUTING.md)
- [Code of conduct](CODE_OF_CONDUCT.md)
- [Project notices](NOTICE.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)
- [Security policy](SECURITY.md)

RandomDayGuard is an independent community server-administration utility for
Abiotic Factor dedicated servers that use UE4SS.
