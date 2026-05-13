# Forensic Daily Rollups and Final Logs

This document explains the quick-review package produced by RandomDayGuard.

The goal is simple: after a server run, crash window, or suspicious period, an admin should be able to zip one day folder and upload it for immediate forensic review.

---

## What This Feature Adds

RandomDayGuard keeps the raw evidence files as the source of truth, but also translates the gathered data into daily operator summaries.

It writes two daily locations:

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

It also writes current-day shortcuts:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

The current-day files and the day folder are updated in place. They are not meant to create a new file every poll.

---

## Why This Exists

Before this feature, a review package required many files:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
scan_progress.json
world_state_latest.json
raid_cases/
enforced_bans.jsonl
```

That is good for depth but slow for first-pass review.

The forensic daily rollup creates a summarized package that answers first:

```text
Who joined?
Who left?
Who rapidly reconnected?
Who overlapped crashes?
Who returned after crashes?
Who has warning overlap?
Who is REVIEW?
Who is BAN-ELIGIBLE?
Which gates blocked Admin.ini writing?
What files support the decision?
```

---

## Daily Folder Contents

Expected files:

| File | Purpose |
|---|---|
| `forensic_day_summary.json` | Full machine-readable daily summary. |
| `forensic_day_summary.md` | Human-readable summary for admins. |
| `forensic_day_summary.txt` | Plain-language final log for quick review. |
| `players.tsv` | Player/account table for the day. |
| `sessions.tsv` | Join/leave/session table. |
| `ban_recommendations.tsv` | Ban candidates, clean `BannedPlayer=<ID>` lines, and blocked gates. |
| `crash_reconnects.tsv` | Crash/restart/reconnect context. |
| `warning_bursts.tsv` | Warning/anomaly context. |
| `raid_cases.tsv` | Multi-account cluster context. |
| `world_context.tsv` | Scan/baseline/world-state context. |
| `enforcement_audit.tsv` | Enforcement actions if writing was enabled. |
| `evidence_index.json` | Source files used to create the summary. |

For quick external analysis, zip:

```text
runtime/forensic_days/YYYY-MM-DD/
```

If you want the plain-language version only, use:

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

---

## What The Plain-Language Translator Does

The translator converts runtime fields into operator language.

Example source data:

```text
status = REVIEW
rapid_rejoin_count = 3
crash_overlap_count = 2
post_crash_reconnect_count = 2
warning_overlap_count = 5
```

Plain-language output:

```text
Player needs review because the account shows 3 rapid reconnect patterns, 2 crash/restart overlaps, 2 post-crash returns, and 5 warning/context events.
```

Example ban gate output:

```text
BannedPlayer=123456789 is ban-eligible, but Admin.ini writing is blocked because review_only_mode=true and write_admin_ini=false.
```

The translator does not invent facts. It only explains what the runtime evidence already says.

---

## Source Evidence Remains Authoritative

The daily rollup is a rebuildable index.

Source evidence remains the authority:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/warning_events.jsonl
runtime/raid_cases/
runtime/world_state/current/world_state_latest.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/enforced_bans.jsonl
```

If a daily rollup is damaged, rebuild it from the source evidence.

---

## Crash-Safe Writes

The rollup uses temp-then-rename writes where practical.

Pattern:

```text
forensic_day_summary.json.tmp -> forensic_day_summary.json
forensic_day_summary.txt.tmp -> forensic_day_summary.txt
players.tsv.tmp -> players.tsv
```

If the server crashes mid-write, the last good file should remain readable.

---

## When It Updates

The rollup updates when:

```text
the server starts
player session evidence changes
warnings are recorded
scan progress changes
scan completes
enforcement state changes
scheduled rollup interval passes
```

Default interval:

```lua
forensic_rollup.update_interval_seconds = 30
```

---

## Config

```lua
forensic_rollup = {
    enabled = true,
    write_current_today = true,
    write_daily_folder = true,
        update_interval_seconds = 30,
    rebuild_on_start = true,
    rebuild_after_crash_recovery = true,
    rebuild_after_scan_checkpoint = true,
    rebuild_after_scan_complete = true,
    rebuild_after_enforcement = true,
    daily_root = "runtime/forensic_days",
    final_log_root = "runtime/final_logs",
    atomic_write = true,
    compact_json = true,
    retention_days = 30,
}
```

---

## Quick Review Workflow

1. Zip the day folder:

```text
runtime/forensic_days/YYYY-MM-DD/
```

2. Upload it for analysis.
3. Start with:

```text
forensic_day_summary.md
players.tsv
ban_recommendations.tsv
forensic_day_summary.txt
```

4. Use `evidence_index.json` to open source files when more proof is needed.

---

## What To Look For

In `players.tsv`:

```text
status
recommended_action
rapid_rejoin_count
crash_overlap_count
post_crash_reconnect_count
warning_overlap_count
admin_ini_line
reason
```

In `ban_recommendations.tsv`:

```text
admin_ini_line
gates_passed
blocked_by
evidence_files
```

In `final_forensic_log.txt`:

```text
plain-language summary of who needs review and why
```

---

## Important Limits

The daily rollup is not a client anti-cheat report.

It summarizes server evidence. It does not claim direct duplication, direct object damage, exact live coordinates, direct container use, object ownership, or memory-level facts unless readable server evidence exposes those facts.

Indirect evidence remains context. Context can support review, but it is not the same as direct proof.
