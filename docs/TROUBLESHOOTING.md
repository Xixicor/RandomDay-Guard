# Troubleshooting

Use this guide when RandomDayGuard does not load, does not write files, does not scan, or does not map players.

---

## Mod Does Not Load

Symptoms:

```text
No runtime folder.
No runtime_version.json.
No startup_status.json.
```

Check:

```text
mods.txt contains: RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
RandomDayGuard/scripts/main.lua exists
config.lua exists
```

Verify installed path:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Do not install as:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

---

## Wrong Version Loaded

Symptoms:

```text
runtime_version.json shows old version.
README says new version but runtime does not.
```

Fix:

```text
Stop server.
Delete old RandomDayGuard folder.
Extract ZIP again.
Verify Scripts/main.lua and scripts/main.lua.
Start server.
```

Terminal checks:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
grep -n "local VERSION" RandomDayGuard/scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

---

## Saved Folder Not Found

Symptoms:

```text
saved_path_probe.json shows failed candidates.
No Admin.ini found.
No Logs found.
No World saves found.
```

Fix:

```text
Edit SavedRoot.txt.
Point it to AbioticFactor/Saved.
Do not point it to Worlds/<WorldName>.
```

Correct:

```text
/AMP/<server>/AbioticFactor/Saved
```

Wrong:

```text
/AMP/<server>/AbioticFactor/Saved/SaveGames/Server/Worlds/<WorldName>
```

---

## Poll Loop Stuck

Symptoms:

```text
poll_id stops increasing
poll_in_flight stays true
scheduler_status not running
poll_error.txt exists
```

Check:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
runtime/logs/current.jsonl
```

Likely causes:

```text
blocking scan work in poll path
large file read in live path
Lua error in event processing
bad Saved path causing repeated failures
```

---

## Scan Does Not Start

Symptoms:

```text
scan_progress.json missing
scan_job_active=false
scan_phase missing
```

Check:

```text
runtime/current/poll_status.json
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
startup_scan_gate
```

Expected gate:

```text
active_log_caught_up=true
active_log_unread_bytes=0
log_backlog_pending=false
poll_id > 1
```

If active log is duplicated, check:

```text
active_log_duplicate_count
active_log_unique_count
active_log_files
```

---

## Scan Starts But Never Completes

Symptoms:

```text
scan_progress.json exists
phase stays the same for a long time
files_done does not increase
```

Check:

```text
current_file
budget_exhausted
errors
scan_checkpoint.json
```

Interpretation:

```text
budget_exhausted=true can be normal if progress continues.
files_done stuck means scan is blocked or erroring.
```

If the server restarts, check that `scan_checkpoint.json` resumes near the prior file index.

---

## Scan Restarts From Zero After Crash

Symptoms:

```text
files_done was high before crash
after restart files_done returns to 0
```

Check:

```text
runtime/scan_checkpoint.json
runtime/scan_manifest.tsv
runtime/baselines/in_progress_scan.json
saved_root identity
world folder identity
```

Likely causes:

```text
checkpoint missing
manifest missing
SavedRoot changed
world folder changed
checkpoint marked stale
```

If the world folder changed, starting a new baseline may be correct.

---

## Player Is Unmapped

Symptoms:

```text
account_id = unmapped_name:<name>
ban_id missing
identity_confidence = unmapped_presence_only
```

Check:

```text
runtime/evidence/session_events.jsonl
runtime/logs/current.jsonl
Saved/Logs/AbioticFactor.log
```

Look for:

```text
Login request
Name=<player>
ConnectID=
UniqueId=
```

If the name appears only in chat/presence lines, there may be no clean ban ID yet.

---

## Wrong Name / Same-Poll Mapping Issue

Symptoms:

```text
Login request and join happened close together.
Session still became unmapped.
```

Expected behavior:

```text
Join events should be re-resolved before evidence append/apply.
```

Check:

```text
PLAYER_LOGIN_IDENTITY
PLAYER_JOIN_STATE
SESSION_JOIN
identity_confidence
```

If this fails, preserve the runtime evidence and report it as an identity mapping bug.

---

## Admin.ini Did Not Change

Symptoms:

```text
Expected ban not written.
Admin.ini unchanged.
```

Check config:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
require_clean_ban_id = true
```

Check gates:

```text
ban_id clean numeric
not trusted
not moderator
threshold met
account-specific evidence exists
```

Check files:

```text
runtime/ban_queue.json
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/evidence/enforcement_failed_<timestamp>.json
runtime/backups/
```

---

## Admin.ini Change Did Not Persist

Symptoms:

```text
Ban appears, then disappears after restart.
```

Likely causes:

```text
wrong Admin.ini path
server rewrote file
file edited while server running
missing [BannedPlayers] section
permission issue
```

Fix:

```text
Stop server.
Back up Admin.ini.
Edit correct Saved/SaveGames/Server/Admin.ini.
Start server.
Reopen file after restart to verify persistence.
```

---

## GitHub Validation Failed

Common validator failures:

| Failure | Meaning |
|---|---|
| README missing section | README headings do not match validator expectations. |
| Unsafe BannedPlayer example | Docs show suffix or name after `BannedPlayer=`. |
| Runtime artifact in ZIP | Release ZIP includes generated files instead of `.gitkeep`. |
| Scripts mismatch | `Scripts/main.lua` and `scripts/main.lua` differ. |
| Version mismatch | VERSION/config/build marker/release notes disagree. |
| Private name hit | Docs/config contain private server/player/world strings. |

Fix the specific file and rerun:

```sh
python tools/validate_repo.py
python tools/build_release_zip.py
python tools/validate_repo.py
```

---

## What To Collect Before Asking For Help

Collect sanitized copies of:

```text
runtime/runtime_version.json
runtime/startup_status.json
runtime/current/poll_status.json
runtime/saved_path_probe.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/poll_error.txt if present
runtime/startup_error.txt if present
runtime/scan_error.txt if present
```

Do not post raw private player IDs, Admin.ini, PlayerData, world saves, or server logs publicly.
## Forensic Rollup Files Missing

Check:

```text
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Missing source files should appear as missing/not available in the summary instead of crashing the runtime.
