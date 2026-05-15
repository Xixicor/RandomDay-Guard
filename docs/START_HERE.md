# Start here

Use this page for the first install, first boot, or clean reinstall.

## At a glance

| Item | Value |
|---|---|
| Mod folder | `RandomDayGuard/` |
| Runtime | UE4SS Lua |
| Install target | `AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/` |
| Default mode | Review only |
| First health file | `runtime/current/poll_status.json` |
| First player file | `runtime/account_evidence.json` |
| First quick-review folder | `runtime/forensic_days/YYYY-MM-DD/` |

## 1. Install

1. Stop the server.
2. Delete the old `RandomDayGuard` folder if one exists.
3. Extract the release ZIP into:

   ```text
   AbioticFactor/Binaries/Win64/ue4ss/Mods/
   ```

4. Confirm this final path exists:

   ```text
   AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/Scripts/main.lua
   ```

5. Enable the mod in `mods.txt`:

   ```text
   RandomDayGuard : 1
   ```

6. Start the server.

Do not replace files while the server is running and assume UE4SS reloaded them. Stop, replace, verify, then start.

## 2. Set the Saved folder

Set `RandomDayGuard/SavedRoot.txt` only if auto-detection fails.

Correct:

```text
/AMP/<server>/AbioticFactor/Saved
Z:/AMP/<server>/AbioticFactor/Saved
```

Wrong:

```text
Saved/SaveGames/Server/Worlds/<WorldName>
```

`SavedRoot.txt` must point at `Saved/` because the guard needs logs, `Admin.ini`, world files, PlayerData, and backups.

## 3. Keep the first run safe

Use review mode first:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

This records evidence without editing `Admin.ini`.

## 4. Check that it loaded

Open:

```text
runtime/runtime_version.json
runtime/startup_status.json
runtime/current/poll_status.json
```

Healthy poll state:

```json
{
  "scheduler_status": "running",
  "poll_scheduled": true,
  "poll_in_flight": false
}
```

`poll_id` should increase over time.

## 5. Test one join and leave

1. Join with a test account.
2. Leave cleanly.
3. Open:

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
Normal session remains INFO.
```

## 6. Watch the first scan

Open:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

A partial scan is normal:

```json
{
  "scan_complete": false,
  "generated_from_partial_scan": true
}
```

After the scan completes, check:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/baselines/file_manifest.tsv
runtime/baselines/last_completed_baseline.json
```

## 7. Create a sticky backup

After a completed baseline, back up:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

This gives you a known-good recovery point.

## Next docs

| Next task | Read |
|---|---|
| Pick config profile | [`CONFIG_PROFILES.md`](CONFIG_PROFILES.md) |
| Understand outputs | [`MEMORY_ECONOMY_AND_OUTPUTS.md`](MEMORY_ECONOMY_AND_OUTPUTS.md) |
| Daily quick upload | [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md) |
| Troubleshooting | [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) |
