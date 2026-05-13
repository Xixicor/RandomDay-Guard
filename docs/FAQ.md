# FAQ

## Is RandomDayGuard the RandomDay Mod?

No.

RandomDay Mod controls the rotating server experience.

RandomDayGuard watches the server evidence layer and helps with sessions, crashes, reconnects, world context, reports, and optional enforcement.

---

## Does it work before the full scan completes?

Yes. Live defense should work from logs and session events before baseline completion.

The baseline scan improves precision later.

---

## Why can the first scan take a long time?

The first scan may inspect many Saved files.

It builds:

```text
object registry
world-state context
file manifest
baseline cache
```

The important part is that it checkpoints and should resume instead of starting from zero after interruption.

---

## What should I check first after startup?

Open:

```text
runtime/current/poll_status.json
```

Look for:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

---

## Where are player profiles summarized?

Open:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

---

## Where is the session timeline?

Open:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
```

---

## Where is crash/restart evidence?

Open:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/lifecycle_events.jsonl
```

---

## Where is scan progress?

Open:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
```

---

## What is a partial world state?

A partial world-state file is written before the full scan completes.

It should say:

```json
{
  "scan_complete": false,
  "generated_from_partial_scan": true
}
```

Use it as context, not a completed baseline.

---

## When is the baseline complete?

Check for:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

---

## Can it write bans automatically?

Only if explicitly configured.

Default:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

---

## What does Admin.ini receive?

Only clean lines:

```ini
BannedPlayer=<ID>
```

Reasons and evidence go into runtime files.

---

## Is a display name enough to ban?

No.

The strongest source is a server log Login request containing:

```text
Name=
ConnectID=
UniqueId=
```

---

## What if ConnectID has a suffix?

Use only the numeric prefix.

Example raw value:

```text
2535422284688820_+_|...
```

Admin.ini gets:

```ini
BannedPlayer=2535422284688820
```

---

## Can a crash alone ban someone?

No by default.

One crash is context. Repeated account-specific crash overlap and post-crash reconnect behavior can become review evidence.

---

## Can object count alone ban someone?

No by default.

Object/class changes are context unless correlated with account-specific evidence and thresholds.

---

## Should SavedRoot.txt point at the world folder?

No.

Point it at:

```text
AbioticFactor/Saved
```

not:

```text
Saved/SaveGames/Server/Worlds/<WorldName>
```

---

## What happens if the world folder changes?

RandomDayGuard should treat that as a baseline identity change.

Same world renamed:

```text
reuse where fingerprints match
```

Different/restored world:

```text
preserve old baseline
start new baseline generation
```

---

## Should I post runtime files publicly?

Only sanitized files.

Do not publicly post raw private logs, Admin.ini, PlayerData, world saves, private IDs, or incident data.
## What should I upload for quick review?

Zip one of these folders:

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

The daily summary is a rebuildable index. Keep raw runtime evidence for final verification.
