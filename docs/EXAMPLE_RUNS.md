# Example Runs

These examples show how RandomDayGuard output should be interpreted.

All IDs, names, and paths are placeholders.

---

## Example 1 — Normal Join And Leave

Timeline:

```text
00:00 server running
00:02 Login request for ExamplePlayer
00:02 ExamplePlayer entered facility
00:12 ExamplePlayer exited facility
```

Expected files:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/current/session_state.json
```

Expected account summary:

```text
join_count = 1
leave_count = 1
clean_leave_count = 1
unclean_disconnect_count = 0
status = INFO
```

Decision:

```text
No review.
No ban.
```

---

## Example 2 — Rapid Reconnect Churn

Timeline:

```text
00:00 join
00:01 leave
00:02 join
00:03 leave
00:04 join
```

Expected changes:

```text
rapid_rejoin_count increases
session_churn_score increases
session_events.jsonl grows
account_evidence.json updates
```

Decision:

```text
WATCH or REVIEW depending on thresholds.
No auto-ban from churn alone by default.
```

---

## Example 3 — Crash-Correlated Return

Timeline:

```text
00:00 account joins
00:03 server crash or unknown gap
00:05 server restarts
00:06 same account joins
00:10 server crashes again
00:12 same account returns again
```

Expected files:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/session_events.jsonl
runtime/account_evidence.json
runtime/evidence/crash_reconnect_events.jsonl
```

Expected counters:

```text
server_crash_overlap_count increases
post_crash_reconnect_count increases
unclean_disconnect_count may increase
crash_abuse_score increases
```

Decision:

```text
REVIEW if repeated.
BAN-ELIGIBLE only if thresholds and enforcement gates pass.
```

---

## Example 4 — First Full Scan Still Running

Timeline:

```text
00:00 server starts
00:01 scan starts
00:10 scan still running
```

Expected files:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
```

Example:

```json
{
  "phase": "scanning",
  "active": true,
  "complete": false,
  "files_done": 141,
  "total_files": 1767,
  "entries_seen": 2888
}
```

Decision:

```text
Scan is working.
Baseline is partial.
Live defense should still be active.
```

---

## Example 5 — Restart During Scan

Before restart:

```text
files_done = 141
total_files = 1767
```

After restart, expected behavior:

```text
scan_checkpoint.json is loaded
scan resumes near file 141
or already scanned files are skipped through cache
```

Problem sign:

```text
files_done returns to 0 every restart with no stale-world explanation
```

Check:

```text
scan_checkpoint.json
scan_manifest.tsv
SavedRoot.txt
world folder identity
```

---

## Example 6 — Completed Baseline Then Normal Boot

After baseline completion:

```text
scan_complete.json exists
object_registry.json exists
file_manifest.tsv exists
last_completed_baseline.json exists
world_state_latest.json has scan_complete=true
```

Next boot:

```text
baseline loads quickly
world_state_latest.json appears early
changed-file refresh starts
unchanged files are reused where supported
```

Decision:

```text
Server has reusable world context.
Future scans should be lighter.
```

---

## Example 7 — World Folder Changed

Old:

```text
Saved/SaveGames/Server/Worlds/OldWorld/
```

New:

```text
Saved/SaveGames/Server/Worlds/NewWorld/
```

Expected behavior:

```text
old baseline preserved
checkpoint checked against current world identity
new baseline generation starts if identity changed
previous baseline not overwritten until new one completes
```

Decision:

```text
Treat as baseline identity change, not a small refresh.
```

---

## Example 8 — Warning Burst During Mapped Session

Timeline:

```text
mapped account joins
ActorChannelFailure burst occurs
account leaves
```

Expected files:

```text
runtime/warning_events.jsonl
runtime/evidence/session_events.jsonl
runtime/warnings/warning_<period>.txt
runtime/account_evidence.json
```

Decision:

```text
Context for review.
Not proof by itself.
Stronger if repeated with same account or crash/reconnect overlap.
```

---

## Example 9 — Enforcement Test Mode

Config:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Expected behavior:

```text
scores/recommendations may appear
Admin.ini is unchanged
enforced_bans.jsonl should not show a new successful write
```

Decision:

```text
Use this mode to validate thresholds before enabling enforcement.
```

---

## Example 10 — Enforcement Enabled

Config:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

If all gates pass, expected files:

```text
runtime/backups/Admin_<timestamp>.ini
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/evidence/enforced_bans.jsonl
```

Admin.ini line:

```ini
BannedPlayer=<ID>
```

Decision:

```text
Admin.ini write occurred.
Review enforced_bans.jsonl and backup file.
```
