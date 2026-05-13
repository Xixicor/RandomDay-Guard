# Configuration Reference

All defaults are public-safe and review-first.

## saved

Controls Saved root candidates and direct-known evidence checks. `SavedRoot.txt` is tested first when non-empty. `saved.allow_full_find_discovery=false` prevents recursive discovery during startup/root probing.

## log_tail

Controls active log tailing. Defaults start new logs at EOF, do not tail backup logs live, and dedupe `/AMP/...` and `Z:/AMP/...` aliases through canonical log keys.

Gate rule: if `active_log_caught_up=true`, `active_log_unread_bytes=0`, and no active-log read failed, `log_backlog_pending=false`.

## runtime

Controls poll cadence and live callback budgets. Poll callbacks must return quickly. Maintenance and scans are deferred or chunked.

## scanning

Controls baseline scan behavior.

- `full_scan_on_start=true`: start a baseline scan after the live gate opens.
- `reuse_completed_baseline=true`: completed baselines are used for immediate visibility where available.
- `resume_incomplete_scan=true`: incomplete checkpoints remain marked partial and can guide the next scan generation.
- `incremental_refresh_after_baseline=true`: changed/new/removed files are refresh candidates.
- `force_full_scan=false`: do not discard completed baselines by default.
- `baseline_manifest_enabled=true`: write `runtime/baselines/file_manifest.tsv`.
- `per_file_entry_cache_enabled=true`: scaffold for per-file entry reuse.
- `changed_file_detection=true`: compare file identity fields before rescanning.
- `targeted_token_extraction=true`: extract known object/class/path token families.
- `fallback_broad_token_scan=false`: broad token fallback is off by default.
- `deep_backup_scan_enabled=false`: deep backup scans are disabled by default.

Recursive discovery is allowed only inside the scan job when `allow_full_find_discovery_only_in_scan_job=true`.

## enforcement

Review-first defaults:

```lua
auto_ban = false
write_admin_ini = false
review_only_mode = true
require_clean_ban_id = true
preserve_moderators = true
preserve_existing_bans = true
```

Auto-ban requires explicit configuration, a clean mapped ban ID, threshold evidence, and non-protected account status.

## warning_report, raid_detection, crash_correlation

These groups control review context. Lifecycle events, crashes, normal restarts, network disruption, object count alone, and one warning burst do not create ban eligibility by themselves.
