# RandomDayGuard docs

Use this folder as the operator manual.

The docs are split by task so you do not have to read one long document. Start with the row that matches what you are doing.

## Start here

| I need to... | Open |
|---|---|
| Install the guard for the first time | [`START_HERE.md`](START_HERE.md) |
| Pick a safe config setup | [`CONFIG_PROFILES.md`](CONFIG_PROFILES.md) |
| Understand all config areas | [`CONFIG_REFERENCE.md`](CONFIG_REFERENCE.md) |
| Know what files the guard writes | [`MEMORY_ECONOMY_AND_OUTPUTS.md`](MEMORY_ECONOMY_AND_OUTPUTS.md) |
| Upload one day for quick review | [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md) |
| Review one suspicious account | [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md) |
| Troubleshoot a failed install or scan | [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) |

## Admin and enforcement

| I need to... | Open |
|---|---|
| Understand clean ban ID handling | [`BAN_ID_MAPPING.md`](BAN_ID_MAPPING.md) |
| Understand Admin.ini writes and rollback | [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md) |
| Understand what each signal means | [`DETECTION_SIGNALS.md`](DETECTION_SIGNALS.md) |
| Review bad-actor and crash patterns | [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](BAD_ACTOR_PATTERNS_AND_RESILIENCE.md) |
| Understand evidence limits | [`EVIDENCE_BOUNDARY.md`](EVIDENCE_BOUNDARY.md) |

## Operations and release work

| I need to... | Open |
|---|---|
| Install on Hostinger / AMP | [`HOSTINGER_AMP_INSTALL.md`](HOSTINGER_AMP_INSTALL.md) |
| Handle a changed world folder | [`WORLD_SAVE_FOLDER_CHANGES.md`](WORLD_SAVE_FOLDER_CHANGES.md) |
| Run day-to-day checks | [`OPERATIONS_PLAYBOOK.md`](OPERATIONS_PLAYBOOK.md) |
| Validate and build the release ZIP | [`VALIDATION_AND_RELEASE.md`](VALIDATION_AND_RELEASE.md) |
| See example timelines | [`EXAMPLE_RUNS.md`](EXAMPLE_RUNS.md) |
| Get quick answers | [`FAQ.md`](FAQ.md) |
| Keep docs consistent | [`DOCS_STYLE_GUIDE.md`](DOCS_STYLE_GUIDE.md) |

## Recommended first-read order

```text
1. START_HERE.md
2. CONFIG_PROFILES.md
3. MEMORY_ECONOMY_AND_OUTPUTS.md
4. FORENSIC_DAILY_ROLLUPS.md
5. PLAYER_REVIEW_WORKFLOW.md
6. TROUBLESHOOTING.md
7. ADMIN_INI_ENFORCEMENT.md
8. BAD_ACTOR_PATTERNS_AND_RESILIENCE.md
9. FAQ.md
```

## How these docs are written

Each doc follows the same pattern:

```text
Purpose
Use when
Quick path
Files to open
Expected output
Problems to avoid
Related docs
```

That keeps the folder browsable instead of forcing every topic into the README.
