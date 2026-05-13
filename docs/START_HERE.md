# Start Here

This is the operator path for a first install or a clean reinstall.

Use this guide when you want to get RandomDayGuard running without reading the whole repository first.

---

## 1. What RandomDayGuard Does

RandomDayGuard watches the dedicated-server evidence layer.

It reads:

```text
Saved/Logs/*.log
Saved/SaveGames/Server/Admin.ini
Saved/SaveGames/Server/Worlds/**/*.sav
Saved/SaveGames/Server/Worlds/**/PlayerData/*.sav
Saved/SaveGames/Server/Backups/**
```

It writes runtime evidence under:

```text
RandomDayGuard/runtime/
```

The two immediate goals are:

```text
1. Live defense from logs, sessions, crashes, and reconnects.
2. World/context baseline from Saved files.
```

Live defense starts first. The baseline scan can take longer.

---

## 2. Install

Stop the server before replacing files.

Install path:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Required files:

```text
RandomDayGuard/enabled.txt
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/Scripts/main.lua
RandomDayGuard/scripts/main.lua
RandomDayGuard/data/detection_events.json
RandomDayGuard/data/warning_types.json
RandomDayGuard/data/object_categories.json
```

Enable in `mods.txt`:

```text
RandomDayGuard : 1
```

Both script paths are included for host compatibility:

```text
Scripts/main.lua
scripts/main.lua
```

They must be identical.

---

## 3. Configure SavedRoot.txt

`SavedRoot.txt` should point to the server `Saved/` folder.

Correct:

```text
/AMP/<server>/AbioticFactor/Saved
```

or:

```text
Z:/AMP/<server>/AbioticFactor/Saved
```

Wrong:

```text
Saved/SaveGames/Server/Worlds/<WorldName>
```

Reason:

```text
RandomDayGuard needs Logs, Admin.ini, Worlds, PlayerData, and Backups.
```

Pointing directly to a world folder hides important evidence.

---

## 4. Keep First Install Safe

Use review-first mode until output is confirmed.

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

This means:

```text
Evidence is recorded.
Review signals can be produced.
Admin.ini is not changed by the guard.
```

Before enabling enforcement, configure trusted IDs and confirm the evidence output is correct.

---

## 5. First Boot Checks

After starting the server, check these files.

| File | Expected result |
|---|---|
| `runtime/runtime_version.json` | Shows the loaded version. |
| `runtime/current/poll_status.json` | Shows the watchdog loop status. |
| `runtime/current/session_state.json` | Appears after session state starts. |
| `runtime/account_evidence.json` | Appears after account/session evidence is written. |
| `runtime/evidence/session_events.jsonl` | Records login/join/leave/session events. |
| `runtime/scan_progress.json` | Appears when the scan starts. |
| `runtime/world_state/current/world_state_latest.json` | Appears when world-state output exists. |

Healthy `poll_status.json` should include:

```json
{
  "scheduler_status": "running",
  "poll_scheduled": true,
  "poll_in_flight": false
}
```

`poll_id` should increase over time.

---

## 6. First Join/Leave Test

Use a non-production test account.

1. Start the server.
2. Join with the test account.
3. Leave cleanly.
4. Open:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/current/session_state.json
```

Expected result:

```text
SESSION_JOIN appears.
SESSION_LEAVE appears.
Account ID and ban ID are mapped if the server log exposed ConnectID.
Status remains INFO for normal behavior.
```

---

## 7. First Scan Expectations

The first broad scan may take time.

Open:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

During scan, `world_state_latest.json` may say:

```json
{
  "scan_complete": false,
  "generated_from_partial_scan": true
}
```

That is valid. It means partial world context exists but the completed baseline is not ready yet.

After completion, check:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

---

## 8. What To Send For Support

If asking for help, send these files first:

```text
runtime/runtime_version.json
runtime/startup_status.json
runtime/current/poll_status.json
runtime/saved_path_probe.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
```

Do not send private server logs, PlayerData, world saves, or Admin.ini publicly unless you have sanitized them.
