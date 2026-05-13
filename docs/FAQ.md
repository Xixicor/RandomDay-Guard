# FAQ

## Is RandomDayGuard the RandomDay Mod?

No. RandomDay Mod changes the server experience. RandomDayGuard watches the server evidence layer.

## Does live defense work before the scan completes?

Yes. Live defense uses logs and session events. The baseline scan improves context later.

## Why can the first scan take a long time?

The first scan builds world/object context, file manifests, and reusable baseline data.

## What do I check first after startup?

```text
runtime/current/poll_status.json
```

Look for:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

## Where are player summaries?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

## Where is the daily quick-review package?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

## Which file should I upload for fastest review?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

## Can it write bans automatically?

Only if explicitly enabled.

Default:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

## What does Admin.ini receive?

Only:

```ini
BannedPlayer=<ID>
```

No names, comments, reasons, or suffixes.

## Is a display name enough to ban?

No. Use a server log `Login request` with `ConnectID` or equivalent server evidence.

## Can one crash ban someone?

No by default.

## Can object count alone ban someone?

No by default.

## Should SavedRoot.txt point to the world folder?

No. Point it to `AbioticFactor/Saved`.

## What if the world folder changes?

Treat it as a baseline identity change. Preserve old baseline and build a new one.

## Related docs

* [`START_HERE.md`](START_HERE.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)
