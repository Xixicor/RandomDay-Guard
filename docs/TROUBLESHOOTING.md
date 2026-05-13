# Troubleshooting

Use this page when the guard does not load, does not scan, or does not write expected files.

## No runtime files

Check:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
RandomDayGuard/scripts/main.lua exists
```

Correct install path:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Wrong nested path:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

## Wrong version loaded

Check:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
grep -n "local VERSION" RandomDayGuard/scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Fix:

```text
Stop server.
Delete old RandomDayGuard folder.
Extract release again.
Start server.
```

## Saved folder not found

Open:

```text
runtime/saved_path_probe.json
```

Fix `SavedRoot.txt`:

```text
/AMP/<server>/AbioticFactor/Saved
```

Do not point to `Worlds/<WorldName>`.

## Poll loop stuck

Open:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Problem signs:

```text
poll_id does not increase
poll_in_flight stays true
scheduler_status is not running
```

## Scan does not start

Open:

```text
runtime/current/poll_status.json
```

Check:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

Startup scan should wait until active log backlog is clear.

## Scan restarts after every crash

Open:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Likely causes:

```text
checkpoint missing
manifest missing
SavedRoot changed
world folder changed
checkpoint marked stale
```

## Player is unmapped

Open:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Look for:

```text
Login request
Name=
ConnectID=
UniqueId=
```

If no ConnectID exists, do not treat the display name as enforceable.

## Admin.ini did not change

Check config:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Check gates:

```text
ban_id clean numeric
not trusted
not moderator
threshold met
account-specific evidence exists
```

## Daily rollup missing

Check:

```text
forensic_rollup.enabled = true
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

If missing, check startup/poll errors and whether the feature is enabled.

## GitHub validation failed

Common reasons:

| Error | Fix |
|---|---|
| README section missing | Restore exact required heading |
| Unsafe `BannedPlayer=` example | Use only `BannedPlayer=<ID>` |
| Runtime artifact in ZIP | Build script must exclude generated files |
| Script paths differ | Make `scripts/main.lua` match `Scripts/main.lua` |
| Version mismatch | Set all markers to `v0.4.11-alpha` |

## Related docs

* [`VALIDATION_AND_RELEASE.md`](VALIDATION_AND_RELEASE.md)
* [`START_HERE.md`](START_HERE.md)
