# RandomDayGuard

RandomDayGuard is a separately installable AMP / Hostinger / Abiotic Factor dedicated-server guard addon for the RandomDay Mod.

RandomDay Mod controls rotating gameplay conditions. RandomDayGuard watches, records, and protects the dedicated-server evidence layer.

## 30-Second Summary

RandomDayGuard is a UE4SS Lua watchdog that reads server-owned evidence from the Abiotic Factor `Saved/` folder. It tails server logs, maps login identity from `Name`, `ConnectID`, and `UniqueId` lines, tracks sessions, records clean and unclean exits, follows crash/restart continuity, and builds Saved-folder object and world-state context.

Live defense starts immediately from log evidence. The broader baseline scan runs later in chunks, writes progress and checkpoint files, and improves world/object precision after it completes.

## Current Release

- Version: `v0.4.11-alpha`
- Runtime: UE4SS Lua
- Target: Abiotic Factor dedicated servers
- Host layouts: AMP, Hostinger VPS, Wine paths, and Windows paths
- Release ZIP: `RandomDayGuard_v0.4.11-alpha.zip`

## What It Reads

RandomDayGuard uses readable Saved-folder and log-derived evidence only:

```text
Saved/Logs/*.log
Saved/SaveGames/Server/Admin.ini
Saved/SaveGames/Server/Worlds/**/*.sav
Saved/SaveGames/Server/Worlds/**/PlayerData/*.sav
Saved/SaveGames/Server/Backups/**
Saved/SaveGames/Server/SandboxSettings.ini
Saved/Config/WindowsServer/SandboxSettings.ini
```

For `.sav` files it extracts visible strings and paths. It does not deserialize Unreal save data.

## What It Writes

Common runtime outputs include:

```text
runtime/current/poll_status.json
runtime/current/live_defense_state.json
runtime/evidence/session_events.jsonl
runtime/evidence/live_defense_events.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/world_state/current/world_state_latest.json
runtime/baselines/file_manifest.tsv
runtime/baselines/last_completed_baseline.json
runtime/enforced_bans.jsonl
```

The release ZIP contains only empty runtime placeholder folders. Runtime evidence is generated on the server.

## How It Works Internally

Boot sequence:

1. UE4SS loads `main.lua`.
2. RandomDayGuard loads `config.lua`.
3. The Saved root is resolved from `SavedRoot.txt`, configured candidates, and direct-known evidence checks.
4. Active log tailing initializes and starts at EOF on first run by default.
5. The poll loop starts and must return quickly.
6. Live defense starts from new log lines.
7. Any completed baseline/checkpoint context is loaded where available.
8. The scan job runs in bounded chunks after the active log is caught up.
9. Partial and final object/world outputs are written as evidence improves.

## Layer 1: Immediate Live Defense

Live defense is log-based and does not require a completed baseline. It detects:

- Login identity from server log `Login request` lines.
- Player joins and leaves.
- Clean leave, timeout, network failure, crash, and restart context.
- Rapid reconnects and post-crash returns.
- Session churn and warning/failure overlap.

Examples:

- Normal session: a mapped login joins, leaves cleanly, and remains `INFO`.
- Suspicious reconnect churn: repeated mapped joins/leaves can become `REVIEW` when thresholds are met.
- Crash-correlated return: active players before a crash are context only unless account-specific evidence repeats across windows.

## Layer 2: Baseline Scan and World Assessment

The baseline scan reads Saved files in chunks and extracts visible object, item, class, and path tokens. It builds object registries and world-state summaries. World actor save-touch events such as `UpdateActorToWorldSave` are treated as spatial context markers, not proof of player action.

Object count alone, one warning burst, one crash, lag, high ping, or one strange Saved entry is not enforcement evidence by itself.

## First Full Scan, Checkpoint, and Resume

The first broad scan may be long on large servers. RandomDayGuard writes `scan_progress.json`, `scan_checkpoint.json`, `object_registry_partial.json`, and `world_state_latest.json` with `scan_complete=false` while scanning. If the server restarts before completion, the partial evidence remains marked as partial. Completed baselines are written separately so later boots can regain visibility quickly.

## After First Baseline

After a completed baseline exists, RandomDayGuard can load the completed baseline outputs immediately and then refresh by scanning changed, new, or removed files. Unchanged file entries are designed to be reusable by manifest/cache data instead of forcing all decisions to wait for a full rescan.

## Changed-File Refresh

Files are candidates for refresh when their path is new, removed, size changed, timestamp changed where available, or fingerprint changed. Unchanged entries can be reused from the baseline manifest/cache. This design keeps live defense responsive while object/world evidence catches up.

## Single-World Save Folder Support

Abiotic Factor dedicated servers normally keep active worlds under:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` should point to the `Saved/` folder, not directly to the world folder. RandomDayGuard discovers world folders under the Saved root.

## If The Active World Folder Changes

- Same world renamed: reuse evidence where file fingerprints match.
- Different or restored world: create a new baseline generation.
- Incomplete checkpoint plus changed world: mark the checkpoint stale and preserve the old partial evidence.
- Completed baseline plus changed world: keep the previous baseline for visibility and safely build a new baseline.

## Enforcement Model

Defaults are review-first:

```lua
auto_ban = false
write_admin_ini = false
review_only_mode = true
```

If enforcement is explicitly enabled, `Admin.ini` receives only clean lines:

```ini
BannedPlayer=<ID>
```

Reasons, thresholds, names, and evidence are written to runtime evidence files, not to `Admin.ini`.

## Evidence Boundary

RandomDayGuard does not claim exact live coordinates, direct item duplication, direct object damage, direct container use, item theft, inventory actions, object ownership, live ping, memory inspection, or client anti-cheat behavior unless readable server logs or Saved files expose those facts directly.

Display names are not ban IDs. The primary ban-ID source is a server log Login request with `ConnectID`; only the leading numeric prefix is used for `BannedPlayer=<ID>`.

## Install

Install to:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Expected files:

```text
enabled.txt
config.lua
SavedRoot.txt
Scripts/main.lua
scripts/main.lua
```

Enable in `mods.txt`:

```text
RandomDayGuard : 1
```

## Hostinger/AMP Checks

Before starting the server, verify the installed files through SSH or Browser Terminal:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
grep -n "local VERSION" RandomDayGuard/scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
cat RandomDayGuard/SavedRoot.txt
```

Stop the server before replacing files. Delete the old `RandomDayGuard` folder, extract the verified ZIP, verify versions/checksums on disk, then start the server.

## First-Run Checklist

After startup, check:

- `runtime/runtime_version.json`
- `runtime/current/poll_status.json`
- `runtime/current/live_defense_state.json`
- `runtime/scan_progress.json`
- `runtime/world_state/current/world_state_latest.json`
- `runtime/scan_complete.json` after baseline completion

## Relationship To RandomDay Mod

RandomDay Mod runs the rotating server experience. RandomDayGuard watches, records, and protects the dedicated-server evidence layer.

## Disclaimer

RandomDayGuard is an independent community server-administration utility. It is not affiliated with or endorsed by Deep Field Games, Playstack, UE4SS, AMP, Hostinger, or platform providers.
