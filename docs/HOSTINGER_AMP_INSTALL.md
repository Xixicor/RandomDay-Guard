# Hostinger / AMP install

Use this page when installing on Hostinger VPS, AMP, or Wine-style paths.

## Install path

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

## Steps

1. Stop the server in AMP.
2. Delete the old `RandomDayGuard` folder.
3. Upload the release ZIP.
4. Extract it into `ue4ss/Mods/`.
5. Confirm:

   ```text
   RandomDayGuard/Scripts/main.lua
   RandomDayGuard/scripts/main.lua
   RandomDayGuard/config.lua
   RandomDayGuard/SavedRoot.txt
   ```

6. Enable in `mods.txt`:

   ```text
   RandomDayGuard : 1
   ```

7. Start the server.
8. Check runtime output.

## SavedRoot.txt

Use:

```text
/AMP/<server>/AbioticFactor/Saved
Z:/AMP/<server>/AbioticFactor/Saved
```

Do not use:

```text
Saved/SaveGames/Server/Worlds/<WorldName>
```

## Terminal checks

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

## First runtime checks

```text
runtime/runtime_version.json
runtime/startup_status.json
runtime/current/poll_status.json
runtime/saved_path_probe.json
runtime/account_evidence.json
```

## Common install problems

| Problem | Check |
|---|---|
| No runtime folder | mod path, `enabled.txt`, `mods.txt` |
| Wrong version | old folder not deleted |
| Saved not found | `SavedRoot.txt`, `saved_path_probe.json` |
| Script not loading | both `Scripts/main.lua` and `scripts/main.lua` |
| No player evidence | active log path and join/leave test |

## Related docs

* [`START_HERE.md`](START_HERE.md)
* [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)
