# RandomDayGuard Documentation Index

Use this page to find the right document quickly.

## Start by task

| I want to... | Read this |
|---|---|
| Install the guard on AMP or Hostinger | `HOSTINGER_AMP_INSTALL.md` |
| Configure the first safe setup | `CONFIG_REFERENCE.md` |
| Understand the runtime design | `ARCHITECTURE.md` |
| Check whether the guard is alive | `OPERATIONS_PLAYBOOK.md` |
| Understand output files | `OPERATIONS_PLAYBOOK.md` |
| Handle a world folder rename or restore | `WORLD_SAVE_FOLDER_CHANGES.md` |
| Map a player name to a ban ID safely | `BAN_ID_MAPPING.md` |
| Understand what evidence can and cannot prove | `EVIDENCE_BOUNDARY.md` |

## Recommended reading order

### First install

1. `HOSTINGER_AMP_INSTALL.md`
2. `CONFIG_REFERENCE.md`
3. `OPERATIONS_PLAYBOOK.md`

### Before enabling enforcement

1. `BAN_ID_MAPPING.md`
2. `CONFIG_REFERENCE.md`
3. `EVIDENCE_BOUNDARY.md`
4. `OPERATIONS_PLAYBOOK.md`

### When troubleshooting scan behavior

1. `OPERATIONS_PLAYBOOK.md`
2. `ARCHITECTURE.md`
3. `WORLD_SAVE_FOLDER_CHANGES.md`

## Runtime files to know first

| File | Why you open it |
|---|---|
| `runtime/current/poll_status.json` | Confirms the watchdog loop is alive. |
| `runtime/current/live_defense_state.json` | Shows live session/crash/churn state. |
| `runtime/evidence/session_events.jsonl` | Shows login, join, and leave events. |
| `runtime/scan_progress.json` | Shows baseline scan progress. |
| `runtime/scan_checkpoint.json` | Shows where an interrupted scan should resume. |
| `runtime/world_state/current/world_state_latest.json` | Shows current world context, partial or complete. |

## Configuration areas by job

| Job | Config groups |
|---|---|
| Find server files | `saved`, `SavedRoot.txt` |
| Track live player behavior | `log_tail`, `join_leave`, `crash_correlation`, `server_lifecycle` |
| Build world context | `scanning`, `object_registry`, `world_state`, `class_categories` |
| Control disk growth | `logging`, `retention`, `warning_report` |
| Review multi-account behavior | `raid_detection`, `warning_bursts`, `accumulation` |
| Write bans after testing | `enforcement`, `admin_ini`, `amp`, `whitelist` |

## Safety defaults

Keep these while testing:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Enable Admin.ini writing only after identity mapping, reports, backups, and trusted IDs are verified.
