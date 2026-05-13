# Install RandomDayGuard

## Requirements

- Abiotic Factor dedicated server.
- UE4SS installed for the server.
- Access to the server filesystem through Hostinger file manager, SSH, Browser Terminal, or another verified file-transfer method.
- The release ZIP: `RandomDayGuard_v0.4.11-alpha.zip`.

## Stable Hostinger/AMP Deployment

Do not assume replacing files while the server is running updates UE4SS-loaded Lua code.

Use this workflow:

1. Stop the server.
2. Delete the old `RandomDayGuard` folder from `Mods/`.
3. Extract the verified ZIP into `AbioticFactor/Binaries/Win64/ue4ss/Mods/`.
4. Verify the files on disk.
5. Start the server.

## Install Path

The final folder should be:

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

Both `Scripts/main.lua` and `scripts/main.lua` are packaged for case-sensitive hosts. They must be identical.

## Enable In UE4SS

In `mods.txt`:

```text
RandomDayGuard : 1
```

## SavedRoot.txt

Leave `SavedRoot.txt` blank for auto-detection, or put the absolute server `Saved/` path in it.

Point it to:

```text
<HostPath>/AbioticFactor/Saved
```

Do not point it directly to:

```text
Saved/SaveGames/Server/Worlds/<WorldName>
```

World folders are discovered under the Saved root.

## Verify Before Start

From SSH or Browser Terminal:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
grep -n "local VERSION" RandomDayGuard/scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
cat RandomDayGuard/SavedRoot.txt
```

Expected version:

```text
v0.4.11-alpha
```

## First Start Verification

After the server starts, check:

```text
RandomDayGuard/runtime/runtime_version.json
RandomDayGuard/runtime/current/poll_status.json
RandomDayGuard/runtime/current/live_defense_state.json
RandomDayGuard/runtime/scan_progress.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
```

`poll_id` should increase over time. `poll_in_flight` should return to `false` between polls.

## Recommended First Test

Join and leave with a test account. Confirm that session evidence appears under runtime evidence/current-state files. Keep:

```lua
auto_ban = false
write_admin_ini = false
review_only_mode = true
```

until the warning report and identity evidence are confirmed for your server.
