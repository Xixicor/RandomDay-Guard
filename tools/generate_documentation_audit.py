#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Callable, Iterable


ROOT = Path(__file__).resolve().parents[1]
CATALOG_PATH = ROOT / "docs" / "CONFIG_FIELD_CATALOG.md"
TRACEABILITY_PATH = ROOT / "docs" / "TRACEABILITY_INDEX.json"


SECTION_CONTRACTS = {
    "top_level": {
        "purpose": "Controls the independent watchdog's master state and public identity.",
        "interaction": "Version identity must stay aligned; the master switch cannot skip any required safety check.",
        "failure": "A disabled master stops collection; identity drift blocks validation and packaging.",
        "recovery": "Restore the shipped identity/default, validate, and restart the Guard.",
    },
    "saved": {
        "purpose": "Selects Saved-root candidates and the server-owned file families eligible for inspection.",
        "interaction": "SavedRoot.txt has operator precedence; scanning switches further narrow the selected root.",
        "failure": "Unreadable or over-broad candidates make sources unavailable and never prove an empty server state.",
        "recovery": "Correct the Saved root, inspect saved_path_probe.json, and rerun bounded discovery.",
    },
    "log_tail": {
        "purpose": "Controls active/backup log registration, first-read position, and per-poll read limits.",
        "interaction": "Runtime poll budgets bound this reader; durable offsets must commit before enforcement evaluation.",
        "failure": "Bad cursor or budget settings can create stale, duplicated, or deferred log evidence.",
        "recovery": "Restore bounded defaults and inspect log_offsets.tsv, log_registry.json, and poll status.",
    },
    "runtime": {
        "purpose": "Defines the poll cadence and bounded work opportunities owned by the scheduler.",
        "interaction": "Each interval gates its owner; line, byte, event, and runtime caps apply within a poll.",
        "failure": "Zero, negative, or extreme values can starve work, overload a poll, or stall current proof.",
        "recovery": "Restore shipped budgets and verify increasing poll_id with no poll left in flight.",
    },
    "logging": {
        "purpose": "Bounds low-importance and actor-touch evidence while retaining correlated events.",
        "interaction": "Aggregation and sampling work with per-poll and per-session caps; correlation may raise importance.",
        "failure": "Overly broad raw logging grows evidence files; overly small caps reduce context and must be reported.",
        "recovery": "Restore aggregate defaults and review raw/event rollups before changing caps again.",
    },
    "retention": {
        "purpose": "Bounds rebuildable runtime evidence, indexes, and rotation while preserving protected records.",
        "interaction": "Retention runs only after summary verification; keep-forever flags override ordinary pruning classes.",
        "failure": "Unsafe limits can discard review context or allow unbounded disk growth.",
        "recovery": "Restore shipped limits, retain authoritative evidence, and rebuild summaries before pruning.",
    },
    "forensic_rollup": {
        "purpose": "Builds current and dated forensic indexes in selected formats.",
        "interaction": "Rebuild triggers share roots, inclusion switches, formats, retention, and atomic replacement policy.",
        "failure": "A missing format or failed replacement leaves the rollup incomplete; source evidence remains authoritative.",
        "recovery": "Repair the output root/write path and rebuild the same evidence window.",
    },
    "source_accounting": {
        "purpose": "Records source scope, availability, current-versus-history boundaries, and top-level truth.",
        "interaction": "Every public report route depends on current source accounting and current-cycle lineage.",
        "failure": "Disabled, non-terminal, or unwritable accounting forces route proof to missing.",
        "recovery": "Restore accounting, repair named sources, and regenerate current-cycle reports and proof.",
    },
    "reports": {
        "purpose": "Selects local report routes, output root, and refresh cadence.",
        "interaction": "A route needs source accounting, structured and translated output, and matching route proof.",
        "failure": "Disabled routes or paired-write/proof failures are missing, never successful.",
        "recovery": "Restore the route/output root and regenerate the same current cycle through route_proof.json.",
    },
    "notification": {
        "purpose": "Controls the optional provider-neutral local-file outbox.",
        "interaction": "Queueing requires a configured route and completed translated report after route proof is durable.",
        "failure": "Unsupported mode, missing proof, or a local write failure produces no delivery claim.",
        "recovery": "Keep notification disabled or repair the local outbox and regenerate from a proven report.",
    },
    "scanning": {
        "purpose": "Controls resumable direct/recursive discovery, baselines, checkpoints, and changed-file scans.",
        "interaction": "Per-tick file, byte, and time budgets bound discovery and scanning; checkpoints own resumption.",
        "failure": "Unsafe discovery or exhausted work remains partial/deferred and cannot prove expected-empty.",
        "recovery": "Restore bounded settings and resume the checkpoint or build a new approved baseline.",
    },
    "admin_ini": {
        "purpose": "Defines the inspected Admin.ini path and mutation safety mechanics.",
        "interaction": "Every write requires a verified backup, duplicate prevention, outside-change detection, and a complete saved-file comparison.",
        "failure": "Parse, path, backup, replacement, external-change, or readback failure closes enforcement.",
        "recovery": "Restore the verified backup and validate clean BannedPlayer=<ID> lines before retrying.",
    },
    "object_registry": {
        "purpose": "Controls Saved-data class-token extraction and first-baseline treatment.",
        "interaction": "Patterns feed class categories, high-risk review, accumulation deltas, and world context.",
        "failure": "Missing/over-broad patterns distort context; class presence never proves player action.",
        "recovery": "Restore reviewed patterns and rebuild the registry from readable Saved evidence.",
    },
    "class_categories": {
        "purpose": "Maps extracted class tokens into named review-context categories.",
        "interaction": "Category patterns annotate registry/delta output but grant no enforcement authority.",
        "failure": "Overlapping or missing patterns change context labels and can obscure review.",
        "recovery": "Restore shipped patterns and regenerate registry and delta outputs.",
    },
    "high_risk_classes": {
        "purpose": "Seeds classes that receive closer review during object-context analysis.",
        "interaction": "Seeds are evaluated with deltas, target context, and account correlation.",
        "failure": "A seed can raise attention but cannot independently authorize enforcement.",
        "recovery": "Restore the shipped seed list and reassess against authoritative evidence.",
    },
    "accumulation": {
        "purpose": "Defines object-delta comparisons and review/critical thresholds.",
        "interaction": "Delta findings require target context and account correlation before enforcement eligibility.",
        "failure": "Missing baselines or unsafe thresholds create misleading context; counts alone never ban.",
        "recovery": "Restore thresholds and rebuild clean start/previous/backup comparisons.",
    },
    "target_context": {
        "purpose": "Enables weak object-layout and relative-coordinate context signals.",
        "interaction": "Signals annotate accumulation findings and remain subordinate to identity/evidence gates.",
        "failure": "Treating a weak signal as ownership or causation would overstate evidence.",
        "recovery": "Restore evidence-only defaults and seek direct account-specific corroboration.",
    },
    "warning_bursts": {
        "purpose": "Defines warning families, rolling windows, and review/critical counts.",
        "interaction": "Each family must be enabled and correlated to active mapped players where configured.",
        "failure": "Bad windows/counts over-trigger or suppress context; a burst alone is not a ban basis.",
        "recovery": "Restore the family defaults and inspect cited log/session evidence.",
    },
    "crash_correlation": {
        "purpose": "Controls repeated failure and post-crash reconnect correlation.",
        "interaction": "Same-account, non-whitelist, grace-window, and rolling-history gates qualify the context.",
        "failure": "A single crash or ambiguous account overlap cannot authorize enforcement.",
        "recovery": "Restore conservative gates and rebuild lifecycle/session correlation.",
    },
    "join_leave": {
        "purpose": "Defines churn history and multi-account join-wave windows.",
        "interaction": "Session mapping and lifecycle grace determine whether joins/leaves are comparable.",
        "failure": "Churn alone is context; unsafe windows can over-group unrelated accounts.",
        "recovery": "Restore shipped windows and review session evidence by account.",
    },
    "server_lifecycle": {
        "purpose": "Defines startup, shutdown, restart, and post-crash continuity windows.",
        "interaction": "Grace windows classify session closure and suppress normal-restart false positives.",
        "failure": "Bad windows misclassify continuity and reconnect context.",
        "recovery": "Restore defaults and start a new server epoch before drawing conclusions.",
    },
    "raid_detection": {
        "purpose": "Groups related account activity into bounded review cases.",
        "interaction": "Link rules create cases; each account still needs its own evidence and score checks.",
        "failure": "Case membership alone cannot make every member guilty or enforceable.",
        "recovery": "Restore conservative links and review each account's cited evidence.",
    },
    "warning_report": {
        "purpose": "Controls bounded per-player/per-session warning report content and rotation.",
        "interaction": "Grouping, context, explanations, thresholds, and decision fields share line/snippet caps.",
        "failure": "A missing/truncated report does not prove warnings absent; event evidence remains authoritative.",
        "recovery": "Repair report generation and rebuild from retained warning/session evidence.",
    },
    "world_state": {
        "purpose": "Selects boot/current/session world-state snapshots and diffs.",
        "interaction": "Session events and selected warning/failure/join-wave triggers refresh snapshots.",
        "failure": "Missing snapshots reduce context; snapshots never prove ownership or causation.",
        "recovery": "Repair scan/write inputs and regenerate the relevant snapshot/diff.",
    },
    "ping": {
        "purpose": "Defines optional log-derived latency context and thresholds.",
        "interaction": "The feature requires a supported log source; ping alone remains excluded from enforcement.",
        "failure": "Unsupported or absent latency evidence must remain unavailable, not fabricated.",
        "recovery": "Keep disabled unless the source is proven; otherwise restore shipped thresholds.",
    },
    "enforcement": {
        "purpose": "Controls the score for automatic action and the safeguards for changing Admin.ini.",
        "interaction": "Before writing, Guard must identify the account, exclude trusted accounts and duplicates, find enough account-specific evidence, verify a backup, reject outside file changes, save the update, and verify the complete result.",
        "failure": "If any required check is disabled, fails, or cannot be confirmed, Guard leaves the ban list unchanged and records why.",
        "recovery": "Return to review-only defaults, read the recorded reason, and correct that check before another approved test.",
    },
    "restart_request": {
        "purpose": "Controls optional local restart request marker/reason files.",
        "interaction": "Marker creation also requires a successful ban and enforcement.request_restart_after_ban.",
        "failure": "A marker write failure or absent external consumer means no restart occurred.",
        "recovery": "Keep disabled or repair the local marker path and verify the operator-owned consumer separately.",
    },
}


EXACT_MEANINGS = {
    "config.enabled": "Starts or suppresses the independent Guard runtime as a whole.",
    "config.version": "Binds config identity to VERSION, BUILD_MARKER, MANIFEST, and both Lua loaders.",
    "config.server_label": "Sets the operator-facing server label without identifying a player or host credential.",
    "config.whitelist": "Maps trusted decimal account IDs to true so they are excluded from enforcement.",
    "config.saved.root_candidates": "Lists ordered local candidates that may resolve to the Abiotic Factor Saved directory.",
    "config.saved.direct_known_files": "Lists Saved-relative files probed before optional recursive discovery.",
    "config.saved.trust_filenames": "Allows filenames to contribute identity context; false keeps filename identity weak.",
    "config.saved.prefer_internal_content_identity": "Prefers identity parsed from readable content over filename-only context.",
    "config.log_tail.offset_file": "Names the durable per-log cursor table committed after successful event handling.",
    "config.runtime.poll_interval_ms": "Sets scheduler delay between bounded poll opportunities; runtime clamps below 250 ms.",
    "config.logging.low_importance_mode": "Selects aggregate handling for low-importance actor events.",
    "config.forensic_rollup.daily_root": "Selects the runtime root for dated forensic-day packages.",
    "config.forensic_rollup.final_log_root": "Selects the runtime root for final logs and route outputs.",
    "config.source_accounting.require_terminal_status": "Requires each source row to state a terminal or explicitly incomplete source-level condition.",
    "config.source_accounting.distinguish_current_from_historical": "Prevents historical evidence from being presented as current-cycle evidence.",
    "config.source_accounting.slow_world_scan_blocks_current_reports": "Chooses whether an incomplete slow world scan blocks otherwise current report routes.",
    "config.notification.mode": "Selects the only supported notification transport: provider-neutral local_file_outbox.",
    "config.scanning.recursive_discovery_mode": "Identifies the shipped manifest-oriented recursive discovery policy.",
    "config.admin_ini.relative_path": "Locates Admin.ini relative to the selected Saved root.",
    "config.object_registry.new_class_enforcement": "Keeps newly observed classes at log_only; class novelty has no direct enforcement authority.",
    "config.accumulation.count_alone_never_bans": "Keeps object counts subordinate to target context, identity, and account correlation.",
    "config.target_context.no_power_context_is_evidence_only": "Keeps missing power context as a weak review signal rather than enforcement proof.",
    "config.target_context.filename_identity_is_weak": "Declares filename-derived identity insufficient without stronger mapping evidence.",
    "config.crash_correlation.single_crash_never_bans": "Prevents one server crash from becoming an enforcement basis.",
    "config.join_leave.churn_alone_never_bans": "Prevents join/leave churn from becoming an enforcement basis by itself.",
    "config.server_lifecycle.lifecycle_events_are_context_only": "Keeps restart/crash/shutdown observations as operational context rather than player fault.",
    "config.raid_detection.ban_all_accounts_in_case": "Controls case-wide enforcement; false preserves per-account decisions.",
    "config.raid_detection.require_account_specific_evidence": "Requires evidence tied to each account before that account can be enforced.",
    "config.ping.mode": "Selects log-derived ping context; no live network probe is implemented.",
    "config.ping.ban_on_ping_alone": "Prevents latency alone from becoming an enforcement basis.",
    "config.enforcement.enabled": "Enables enforcement evaluation, not automatic mutation by itself.",
    "config.enforcement.auto_ban": "Allows eligible accounts to proceed toward automatic mutation only when every other gate passes.",
    "config.enforcement.review_only_mode": "Keeps eligible findings as recommendations while true.",
    "config.enforcement.write_admin_ini": "Authorizes the Admin.ini mutation branch only when every safety gate also passes.",
    "config.enforcement.request_restart_after_ban": "Allows local restart request markers only after a verified ban write.",
    "config.enforcement.require_playerdata_verified": "Optionally requires current PlayerData filename corroboration for the mapped account.",
    "config.enforcement.minimum_identity_strength": "Sets the minimum identity score on the shipped 0, 10, 50, 70, 100 scale.",
    "config.enforcement.require_clean_ban_id": "Requires a mapped decimal ban ID with no metadata.",
    "config.enforcement.require_backup_success": "Requires a byte-readable Admin.ini backup before mutation.",
    "config.enforcement.require_write_readback": "Requires the new ban ID to be observed in a post-write readback.",
    "config.enforcement.rollback_on_readback_failure": "Requires restoration from the verified backup when readback fails.",
    "config.enforcement.preserve_moderators": "Rejects mutation for IDs listed as moderators in the exact Admin.ini snapshot.",
    "config.enforcement.preserve_existing_bans": "Retains existing clean ban entries and avoids duplicate insertion.",
    "config.enforcement.ban_on_threshold": "Allows threshold eligibility but never bypasses review, identity, trust, or write gates.",
    "config.enforcement.ban_from_lag_alone": "Keeps lag context insufficient for enforcement by itself.",
    "config.enforcement.ban_from_ping_alone": "Keeps ping context insufficient for enforcement by itself.",
    "config.enforcement.ban_from_object_count_alone": "Keeps object counts insufficient for enforcement by themselves.",
    "config.enforcement.ban_from_single_crash": "Keeps one crash insufficient for enforcement.",
    "config.enforcement.ban_from_single_warning_burst": "Keeps one warning burst insufficient for enforcement.",
    "config.enforcement.ban_from_unknown_id": "Prevents enforcement when identity remains unknown or name-only.",
    "config.enforcement.require_account_specific_evidence": "Requires cited evidence mapped to the candidate account.",
    "config.restart_request.restart_marker_file": "Names the local marker written after a verified ban when restart requests are enabled.",
    "config.restart_request.restart_reason_file": "Names the structured local reason record paired with the restart marker.",
}


STRING_VALUES = {
    "config.version": "exactly the shipped version string; operator edits are unsupported",
    "config.logging.low_importance_mode": "`aggregate` (the only shipped public mode)",
    "config.notification.mode": "`local_file_outbox` only",
    "config.scanning.recursive_discovery_mode": "`manifest` (the only shipped public mode)",
    "config.object_registry.new_class_enforcement": "`log_only` only",
    "config.ping.mode": "`log` only",
}


EXACT_BOUNDARIES = {
    "config.server_label": "non-empty operator-facing label; do not place credentials, private paths, or incident details here",
    "config.whitelist": "table keyed by clean decimal account ID with boolean `true` values; an empty table is valid",
}


EXACT_INTERACTIONS = {
    "config.server_label": "Appears in local operator reports and notification envelopes; it does not select a host, player, evidence source, or delivery route.",
    "config.whitelist": "Checked when enforcement eligibility is evaluated; it does not suppress evidence collection, historical continuity, reports, or route proof.",
}


EXACT_FAILURES = {
    "config.server_label": "A blank, malformed, or sensitive label can make operator output unsafe or ambiguous; it never becomes player identity or host proof.",
    "config.whitelist": "Malformed or name-only keys are not trusted identities; enforcement must fail closed for an account whose trusted-ID mapping is not clean.",
}


EXACT_RECOVERY = {
    "config.server_label": "Restore a short neutral label, reload the Guard, and confirm newly generated reports display it without changing evidence content.",
    "config.whitelist": "Use clean decimal account IDs mapped to `true`, reload, and verify identity mapping in review-only mode before any write-enabled test.",
}


OUTPUT_PURPOSES = {
    "runtime/account_evidence.json": "Current structured account identity, score, status, and cited evidence index.",
    "runtime/account_evidence.tsv": "Tabular account review export derived from the current account index.",
    "runtime/admin_state.json": "Parsed Admin.ini moderator/ban snapshot used for review and mutation gates.",
    "runtime/ban_queue.json": "Current recommendation queue with enforcement gate state and eligible accounts.",
    "runtime/config_load_error.txt": "Startup record of a config.lua load or table-shape failure.",
    "runtime/current/active_accounts.json": "Current mapped accounts with live sessions.",
    "runtime/current/actor_touch_rollup.json": "Bounded aggregate of low-importance actor-touch observations.",
    "runtime/current/forensic_today.json": "Structured current-day forensic index.",
    "runtime/current/forensic_today.md": "Markdown current-day forensic index for review.",
    "runtime/current/forensic_today.txt": "Plain-text current-day forensic index for review.",
    "runtime/current/poll_error.json": "Structured current-poll failure tied to boot, epoch, and poll lineage.",
    "runtime/current/poll_status.json": "Canonical current poll/scheduler/checkpoint status.",
    "runtime/current/session_state.json": "Current live and recently closed session state.",
    "runtime/current/spatial_context.json": "Weak relative object/spatial context that does not prove ownership.",
    "runtime/current/startup_error.json": "Structured current startup failure tied to boot and epoch.",
    "runtime/current_server_epoch.json": "Current server epoch and lifecycle classification.",
    "runtime/enforced.txt": "Operator-readable ledger of verified Admin.ini ban writes.",
    "runtime/enforced_bans.jsonl": "Append-only primary enforcement success/fail-closed ledger.",
    "runtime/evidence/crash_reconnect_events.jsonl": "Append-only crash/reconnect correlation evidence.",
    "runtime/evidence/critical_events.jsonl": "Append-only critical-importance evidence events.",
    "runtime/evidence/enforced_bans.jsonl": "Evidence-lane copy of enforcement outcomes.",
    "runtime/evidence/high_events.jsonl": "Append-only high-importance evidence events.",
    "runtime/evidence/lifecycle_events.jsonl": "Append-only server lifecycle context events.",
    "runtime/evidence/live_defense_events.jsonl": "Append-only current live-defense observations.",
    "runtime/evidence/log_continuity_events.jsonl": "Append-only log rotation/truncation/continuity evidence.",
    "runtime/evidence/medium_events.jsonl": "Append-only medium-importance evidence events.",
    "runtime/evidence/session_events.jsonl": "Append-only mapped session evidence events.",
    "runtime/final_logs/historical_backfill_latest.json": "Latest historical source-accounting status, separate from current evidence.",
    "runtime/final_logs/route_proof.json": "Current-cycle proof ledger for all five report routes.",
    "runtime/final_logs/source_accounting_latest.json": "Latest source-level availability and top-level truth accounting.",
    "runtime/history/public_accounts.tsv": "Durable bounded public account continuity ledger used by historical reports.",
    "runtime/loader_probe.json": "Structured evidence that the Lua loader reached bootstrap with recorded capabilities.",
    "runtime/loader_probe.txt": "Plain-text loader bootstrap probe.",
    "runtime/log_continuity_events.jsonl": "Primary append-only log continuity ledger.",
    "runtime/log_offsets.tsv": "Durable per-log committed cursors used to prevent replay or skipped bytes.",
    "runtime/log_registry.json": "Known active/backup log generations and continuity metadata.",
    "runtime/logs/current.jsonl": "Append-only operational event log for the current Guard runtime.",
    "runtime/new_classes_detected.jsonl": "Append-only newly observed class-token review records.",
    "runtime/notifications/notification_status.json": "Latest local outbox eligibility/write outcome by route.",
    "runtime/object_registry.json": "Completed object/class token registry for the latest scan.",
    "runtime/object_registry_counts.tsv": "Completed tabular object/class counts for the latest scan.",
    "runtime/object_registry_counts_partial.tsv": "Partial tabular object/class counts while a bounded scan is incomplete.",
    "runtime/object_registry_partial.json": "Partial structured object/class registry while scanning continues.",
    "runtime/playerdata_index.json": "Current PlayerData filename identity index from readable Saved evidence.",
    "runtime/poll_error.txt": "Plain-text latest poll failure for operator diagnosis.",
    "runtime/poll_status.json": "Compatibility copy of current poll/scheduler status.",
    "runtime/public_pipeline_status.json": "Main-loader report-worker opportunity and last error state.",
    "runtime/raid_cases/index.jsonl": "Append-only index of multi-account review cases.",
    "runtime/raw_events.jsonl": "Append-only normalized source events retained under logging/retention policy.",
    "runtime/request_restart.flag": "Optional local marker requesting operator-owned restart handling.",
    "runtime/restart_reason.json": "Structured reason paired with the optional restart marker.",
    "runtime/runtime_capabilities.json": "Startup snapshot of available Lua/OS/runtime capabilities.",
    "runtime/runtime_version.json": "Current runtime version identity record.",
    "runtime/saved_path_probe.json": "Ranked Saved-root probe results and selected readable candidate.",
    "runtime/scan_checkpoint.json": "Resumable bounded scan cursor and accumulated state.",
    "runtime/scan_complete.json": "Terminal successful scan summary and baseline lineage.",
    "runtime/scan_error.txt": "Terminal scan failure reason.",
    "runtime/scan_progress.json": "Current bounded discovery/scan progress and budget state.",
    "runtime/scan_started.json": "Scan generation start record tied to boot and epoch.",
    "runtime/server_epochs.jsonl": "Append-only server epoch history.",
    "runtime/server_lifecycle_events.jsonl": "Append-only lifecycle classification history.",
    "runtime/session_events.tsv": "Tabular mapped join/leave/session event ledger.",
    "runtime/startup_error.txt": "Plain-text latest startup failure.",
    "runtime/startup_status.json": "Current startup phase, Saved root, scan gate, and scheduler state.",
    "runtime/warning_events.jsonl": "Append-only normalized warning/correlation events.",
    "runtime/world_state/current/world_state_latest.json": "Latest bounded world-state context snapshot.",
}


def table_value(value: object) -> bool:
    return isinstance(value, tuple) and len(value) == 2 and isinstance(value[0], dict) and isinstance(value[1], list)


def flatten_config(table: tuple[dict[str, object], list[object]], prefix: str = "config") -> list[tuple[str, object]]:
    rows: list[tuple[str, object]] = []
    for key, value in table[0].items():
        path = f"{prefix}.{key}"
        if table_value(value) and value[0]:
            rows.extend(flatten_config(value, path))
        else:
            rows.append((path, value))
    return rows


def plain_value(value: object) -> object:
    if not table_value(value):
        return value
    mapping, array = value
    if mapping:
        return {key: plain_value(item) for key, item in mapping.items()}
    if array:
        return [plain_value(item) for item in array]
    return {}


def type_name(value: object) -> str:
    if table_value(value):
        return "array" if value[1] else "map"
    if isinstance(value, bool):
        return "boolean"
    if isinstance(value, int):
        return "integer"
    if isinstance(value, float):
        return "number"
    return "string"


def default_text(value: object) -> str:
    value = plain_value(value)
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=True)
    return json.dumps(value, ensure_ascii=True, separators=(",", ":"))


def section_for(path: str) -> str:
    parts = path.split(".")
    return parts[1] if len(parts) > 2 else "top_level"


def words(name: str) -> str:
    value = name.replace("admin_ini", "Admin.ini").replace("jsonl", "JSONL").replace("tsv", "TSV")
    value = value.replace("playerdata", "PlayerData").replace("ban_id", "ban ID")
    return value.replace("_", " ")


def subject(path: str) -> str:
    parts = path.split(".")
    if "warning_bursts" in parts and len(parts) >= 4:
        return words(parts[-2])
    if "critical_single_class_delta" in parts:
        return parts[-1]
    return words(parts[-1])


def field_meaning(path: str, value: object) -> str:
    if path in EXACT_MEANINGS:
        return EXACT_MEANINGS[path]
    parts = path.split(".")
    key = parts[-1]
    section = section_for(path)
    label = subject(path)
    if ".reports.routes." in path:
        return f"Enables generation of the {words(key)} report route and its current-cycle proof row."
    if ".notification.routes." in path:
        return f"Allows the proven {words(key)} route to create a local outbox envelope."
    if ".forensic_rollup.include." in path:
        return f"Includes {words(key)} evidence in generated forensic rollups."
    if ".forensic_rollup.write_formats." in path:
        return f"Emits the {key.upper() if key != 'markdown' else 'Markdown'} forensic-rollup format."
    if ".class_categories." in path and key == "patterns":
        return f"Lists literal tokens that classify objects as {words(parts[-2])}."
    if ".critical_single_class_delta." in path:
        return f"Sets the critical object-count increase for class {key}."
    if ".enforcement.thresholds." in path:
        return f"Sets the account-specific enforcement threshold for {words(key)}."
    if key == "enabled":
        return f"Turns the {words(section)} owner on or off without bypassing required parent checks."
    if key.endswith("_patterns") or key in {"scan_patterns", "seed_classes", "watched_delta_classes"}:
        return f"Lists literal {label} tokens used by the {words(section)} owner."
    if isinstance(value, bool):
        prefix_actions = {
            "allow_": "Allows", "archive_": "Archives", "auto_": "Automatically performs",
            "backfill_": "Backfills", "baseline_": "Enables", "carry_": "Carries",
            "changed_": "Enables", "close_": "Closes", "compact_": "Uses compact encoding for",
            "compare_": "Compares", "correlate_": "Correlates", "create_": "Creates",
            "dedupe_": "Deduplicates", "deep_": "Enables", "detect_": "Detects",
            "direct_": "Enables", "distinguish_": "Separates", "escalate_": "Escalates",
            "fallback_": "Allows fallback", "first_": "Treats", "force_": "Forces",
            "full_": "Enables", "group_": "Groups", "include_": "Includes",
            "incremental_": "Enables", "keep_": "Preserves", "link_": "Links cases",
            "no_": "Treats", "per_": "Enables", "prefer_": "Prefers",
            "preserve_": "Preserves", "prevent_": "Prevents", "rebuild_": "Rebuilds",
            "register_": "Registers", "require_": "Requires", "rescan_": "Rescans",
            "resume_": "Resumes", "reuse_": "Reuses", "scan_": "Scans",
            "slow_": "Lets", "start_": "Starts", "tail_": "Tails", "targeted_": "Uses targeted",
            "trust_": "Trusts", "update_": "Updates", "write_": "Writes",
        }
        for prefix, action in prefix_actions.items():
            if key.startswith(prefix):
                return f"{action} {words(key[len(prefix):])} within the {words(section)} contract."
        return f"Selects whether {label} participates in the {words(section)} contract."
    if isinstance(value, (int, float)):
        if key.endswith("_interval_seconds"):
            return f"Sets seconds between eligible {words(key[:-17])} opportunities."
        if key.endswith("_seconds"):
            return f"Sets the {words(key[:-8])} duration in seconds."
        if key.endswith("_minutes"):
            return f"Sets the {words(key[:-8])} window in minutes."
        if key.endswith("_hours"):
            return f"Sets the {words(key[:-6])} age/window in hours."
        if key.endswith("_days") or key.endswith("_weeks"):
            unit = "days" if key.endswith("_days") else "weeks"
            base = key[: -(len(unit) + 1)]
            return f"Sets {words(base)} in {unit} for the {words(section)} owner."
        if "max_" in key:
            return f"Caps {words(key.replace('max_', '', 1))} for bounded {words(section)} work."
        if key.endswith("_count"):
            return f"Sets the {label} event/count threshold."
        if key.endswith("_score"):
            return f"Sets the {words(key[:-6])} score threshold."
        return f"Sets the numeric {label} boundary used by {words(section)}."
    if table_value(value):
        return f"Provides the ordered {label} values consumed by {words(section)}."
    if any(token in key for token in ("path", "root", "file")):
        return f"Selects the local {label} used by {words(section)}."
    return f"Selects the supported {label} value for {words(section)}."


def valid_boundary(path: str, value: object) -> str:
    if path in EXACT_BOUNDARIES:
        return EXACT_BOUNDARIES[path]
    if path in STRING_VALUES:
        return STRING_VALUES[path]
    key = path.split(".")[-1]
    kind = type_name(value)
    if kind == "boolean":
        return "`true` or `false`; Lua booleans only"
    if kind == "integer":
        if path == "config.enforcement.minimum_identity_strength":
            return "integer 0..100 on the shipped identity-strength scale"
        if path == "config.runtime.poll_interval_ms":
            return "integer >= 250 ms (smaller values are clamped to 250)"
        if "average_ping_" in path:
            relation = "warn <= critical" if "warn" in path else "critical >= warn"
            return f"integer >= 0 ms; {relation}"
        if key.endswith("review_count") or key == "review_delta_total":
            return "integer >= 1 and <= the sibling critical boundary"
        if key.endswith("critical_count") or key in {"critical_delta_total", "critical_case_min_accounts"}:
            return "integer >= 1 and >= the sibling review boundary"
        if key.endswith("review_score"):
            return "integer >= 0 and <= the paired automatic/critical score"
        if key.endswith("auto_ban_score"):
            return "integer >= 0 and >= the paired review score"
        return "integer >= 1; no hard maximum is enforced, so keep it within host capacity"
    if kind == "number":
        return "finite number >= 0; keep it within the documented section relationship"
    if kind == "array":
        if any(token in path for token in ("root_candidates", "direct_known_files")):
            return "array of non-empty local path strings; no credentials, URLs, or provider routes"
        return "array of non-empty literal strings; duplicates add no supported meaning"
    if kind == "map":
        return "table keyed by clean decimal account ID with boolean `true` values; an empty table is valid"
    if any(token in key for token in ("path", "root", "file")):
        return "non-empty local path in the owning root; output paths stay below `runtime/`"
    return "the shipped string value unless another supported value is explicitly documented"


def field_interactions(path: str) -> str:
    if path in EXACT_INTERACTIONS:
        return EXACT_INTERACTIONS[path]
    section = section_for(path)
    contract = SECTION_CONTRACTS[section]["interaction"]
    if ".reports.routes." in path:
        return "Requires reports.enabled, source accounting, paired JSON/TXT writes, and matching route_proof.json lineage."
    if ".notification.routes." in path:
        return "Requires notification.enabled, mode=local_file_outbox, and a completed proof-bearing route."
    if path.startswith("config.enforcement."):
        return "Combined with every other enforcement, identity, trust, Admin.ini, backup, readback, and rollback gate; no single field authorizes a write."
    if ".warning_bursts." in path:
        family = words(path.split(".")[-2])
        return f"Evaluated with the other {family} fields, active-player correlation, and account/session mapping."
    if ".critical_single_class_delta." in path:
        return "Compared with accumulation review/critical totals; target context and account correlation still remain mandatory."
    return f"For `{path}`, {contract[0].lower() + contract[1:]}"


def field_failure(path: str, value: object) -> str:
    if path in EXACT_FAILURES:
        return EXACT_FAILURES[path]
    section = section_for(path)
    contract = SECTION_CONTRACTS[section]["failure"]
    kind = type_name(value)
    if path.startswith("config.enforcement."):
        return f"An unsafe or failed `{path}` gate must record fail-closed and leave Admin.ini unchanged."
    if kind in {"integer", "number"}:
        return f"A non-numeric or out-of-range `{path}` can starve, over-trigger, or overrun its owner; {contract[0].lower() + contract[1:]}"
    if kind in {"array", "map"}:
        return f"Malformed entries in `{path}` can be ignored or break iteration; {contract[0].lower() + contract[1:]}"
    if kind == "string":
        return f"An unsupported or unreadable `{path}` value is not normalized into success; {contract[0].lower() + contract[1:]}"
    return f"A wrong type or unsafe toggle at `{path}` is not a bypass; {contract[0].lower() + contract[1:]}"


def field_recovery(path: str, value: object) -> str:
    if path in EXACT_RECOVERY:
        return EXACT_RECOVERY[path]
    section = section_for(path)
    shipped = default_text(value)
    recovery = SECTION_CONTRACTS[section]["recovery"]
    return f"Restore `{path}` to `{shipped}` and reload; {recovery[0].lower() + recovery[1:]}"


def escape_cell(value: str) -> str:
    return value.replace("|", "\\|").replace("\r", " ").replace("\n", " ")


def render_catalog(config_table: tuple[dict[str, object], list[object]]) -> str:
    rows = flatten_config(config_table)
    out = [
        "# Complete configuration field catalog",
        "",
        "Generated by `python -B tools/generate_documentation_audit.py --write` from",
        "`RandomDayGuard/config.lua`. The generator parses the pure-data Lua table without",
        "executing it. `python -B tools/generate_documentation_audit.py --check` and the",
        "repository validator require exact generated content and one semantic row per leaf.",
        "Arrays and editable maps count as one leaf and show their shipped contents.",
        "",
        "## Global rules",
        "",
        "- Edit only `RandomDayGuard/config.lua`; every example below is shaped for direct insertion inside its shipped `return { ... }` table.",
        "- The only top-level truth values are `complete`, `complete_with_gaps`, `partial`, and `unavailable`.",
        "- `deferred`, `error`, `malformed`, and `permission_denied` are source-level conditions; route proof remains `full`, `limited_expected_empty`, or `missing`.",
        "- A setting cannot override required evidence, account confirmation, trusted-account protection, backup verification, saved-file comparison, recovery, or current-cycle proof.",
        "- Paths remain local and generic. Never commit account IDs, credentials, provider routes, private incidents, or live evidence.",
        "",
        "## Section contracts",
        "",
        "| Section | Purpose | Interaction | Failure behavior | Recovery |",
        "|---|---|---|---|---|",
    ]
    sections: list[str] = []
    for path, _ in rows:
        section = section_for(path)
        if section not in sections:
            sections.append(section)
    for section in sections:
        meta = SECTION_CONTRACTS[section]
        label = "top level" if section == "top_level" else f"`{section}`"
        out.append("| " + " | ".join(escape_cell(item) for item in (
            label, meta["purpose"], meta["interaction"], meta["failure"], meta["recovery"]
        )) + " |")
    out.extend([
        "",
        "## Every shipped field",
        "",
        "| Field | Type | Default | Meaning | Valid values or range | Interactions | Failure behavior | Recovery |",
        "|---|---|---|---|---|---|---|---|",
    ])
    for path, value in rows:
        cells = (
            f"`{path}`", type_name(value), f"`{default_text(value)}`", field_meaning(path, value),
            valid_boundary(path, value), field_interactions(path), field_failure(path, value), field_recovery(path, value),
        )
        out.append("| " + " | ".join(escape_cell(item) for item in cells) + " |")
    out.extend([
        "",
        "## Change and recovery procedure",
        "",
        "1. Back up the reviewed `config.lua` outside package staging.",
        "2. Change the smallest owning table and keep every field at its documented type.",
        "3. Run the generator `--check`, focused documentation tests, `luac -p` on `config.lua`, and `tools/validate_repo.py` when the shared runtime worktree is stable.",
        "4. Restart the Guard and inspect the owner-specific state/output named above.",
        "5. On any load, source, proof, or write failure, restore the shipped value or reviewed backup; enforcement failures remain fail-closed.",
        "",
    ])
    return "\n".join(out)


PACKAGED_META = {
    "RandomDayGuard/enabled.txt": ("UE4SS addon enable marker.", "UE4SS mod discovery", ["none"], "Allows UE4SS to load the addon when present/enabled.", "Missing or disabled marker prevents startup.", "Restore the packaged marker and restart UE4SS."),
    "RandomDayGuard/config.lua": ("Complete public operator configuration table.", "Scripts/main.lua: load_config", ["all `config.*` leaves in CONFIG_FIELD_CATALOG.md"], "Changes bounded collection, reports, retention, and opt-in actions.", "Lua/load/type drift records config_load_error and can fall back or fail later.", "Restore a reviewed backup or shipped table, validate syntax, and restart."),
    "RandomDayGuard/SavedRoot.txt": ("Optional explicit Abiotic Factor Saved-root override.", "Scripts/main.lua: derive_saved_candidates/find_saved_root", ["config.saved.*"], "Adds the first operator-supplied Saved candidate.", "Wrong/unreadable root leaves sources unavailable; a world-only path is rejected operationally.", "Point to the server Saved directory or leave empty for discovery, then inspect saved_path_probe.json."),
    "RandomDayGuard/BUILD_MARKER.txt": ("Packaged build identity marker.", "Scripts/main.lua startup identity checks", ["config.version"], "Exposes version identity for install/readback checks.", "Divergence blocks validation and makes installation identity ambiguous.", "Restore the exact packaged marker matching VERSION and the canonical loader."),
    "RandomDayGuard/README.txt": ("Packaged English operator quick reference.", "operator", ["none"], "Provides offline install and safety guidance.", "Stale guidance can cause unsafe configuration or incorrect proof claims.", "Regenerate/review documentation and replace only in a new validated release package."),
    "RandomDayGuard/MANIFEST.json": ("Packaged file/version manifest.", "release validator and operator", ["config.version"], "Enumerates installed members and identity metadata.", "Missing/divergent members block release validation.", "Rebuild only through release tooling from reviewed source bytes."),
    "RandomDayGuard/Scripts/main.lua": ("Canonical UE4SS independent-watchdog loader/runtime.", "UE4SS", ["all runtime-owned config sections"], "Reads server-owned evidence and writes bounded local runtime state.", "Startup, scheduler, source, or write failures stay visible and cannot prove completion.", "Repair the owning source block, validate Lua, and preserve/replay authoritative evidence."),
    "RandomDayGuard/Scripts/public_pipeline.lua": ("Provider-neutral source accounting, report translation, route proof, and local outbox module.", "Scripts/main.lua: report worker callback", ["config.source_accounting.*", "config.reports.*", "config.notification.*"], "Atomically replaces report/proof/status files and may queue local envelopes.", "Missing source lineage or any contract write forces route proof to missing.", "Repair the named source/write and regenerate the same current cycle before queueing."),
    "RandomDayGuard/data/detection_events.json": ("Public detection-event names and evidence limits.", "Scripts/main.lua event normalization", ["warning/correlation sections"], "Classifies supported log observations without adding private signatures.", "Malformed or overclaiming definitions block validation or mislabel evidence.", "Restore reviewed public definitions and rerun validation."),
    "RandomDayGuard/data/warning_types.json": ("Public warning-type meanings and review boundaries.", "Scripts/main.lua warning normalization", ["config.warning_bursts.*"], "Labels warning evidence for reports and operator review.", "Bad mappings can hide or overstate warning context.", "Restore reviewed warning definitions and rebuild affected reports."),
    "RandomDayGuard/data/object_categories.json": ("Public object-category vocabulary.", "Scripts/main.lua object registry/categorization", ["config.class_categories.*", "config.object_registry.*"], "Labels extracted class tokens as review context.", "Bad categories distort context but never prove player action.", "Restore public categories and rebuild registry/delta output."),
    "RandomDayGuard/runtime/**/.gitkeep": ("Empty packaged runtime directory placeholders only.", "release builder", ["none"], "Creates writable local output lanes without shipping runtime evidence.", "Any non-placeholder runtime member leaks generated/private state and blocks packaging.", "Remove candidate runtime data outside source control and rebuild from the allowlist."),
}


def output_family(path: str) -> str:
    if path.startswith("runtime/final_logs/") and any(route in path for route in ("server_status", "daily_rollup", "player_activity", "case_review", "critical_guard")):
        return "route_report"
    if path.startswith("runtime/final_logs/") and any(name in path for name in ("route_proof", "source_accounting", "historical_backfill")):
        return "public_contract"
    if path.startswith("runtime/notifications/"):
        return "notification"
    if path == "runtime/public_pipeline_status.json":
        return "report_worker"
    if path.startswith("runtime/world_state/"):
        return "world_state"
    if path.startswith("runtime/scan_") or path.startswith("runtime/baselines/"):
        return "scan"
    if path.startswith("runtime/object_registry") or path.startswith("runtime/new_classes") or path.startswith("runtime/class_deltas"):
        return "object_registry"
    if "enforced" in path or "enforcement_failed" in path or path.startswith("runtime/backups/") or path in {"runtime/admin_state.json", "runtime/ban_queue.json"}:
        return "enforcement"
    if path.startswith("runtime/forensic_days/") or path.startswith("runtime/days/") or path.startswith("runtime/weeks/") or path.startswith("runtime/final_logs/YYYY") or path.startswith("runtime/current/forensic_today"):
        return "forensic"
    if "log_" in path or path.startswith("runtime/logs/") or path.startswith("runtime/raw_events"):
        return "log_tail"
    if "session" in path or "account" in path or path.startswith("runtime/raid_cases/") or "warning" in path:
        return "account_review"
    if "epoch" in path or "lifecycle" in path or "crash_reconnect" in path:
        return "lifecycle"
    if "restart" in path:
        return "restart"
    if "saved_path" in path:
        return "saved_discovery"
    if "loader_probe" in path or "runtime_" in path or "startup" in path or "poll" in path or "config_load" in path:
        return "runtime_status"
    if path.startswith("runtime/evidence/"):
        return "evidence"
    return "runtime_state"


FAMILY_META = {
    "route_report": ("Scripts/public_pipeline.lua: route renderer/pair writer", ["config.reports.*", "config.source_accounting.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#public-report-routes"),
    "public_contract": ("Scripts/public_pipeline.lua: source accounting and route-proof commit", ["config.source_accounting.*", "config.reports.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#route-proof-schema"),
    "notification": ("Scripts/public_pipeline.lua: local outbox writer", ["config.notification.*", "config.reports.routes.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#notification-schemas"),
    "report_worker": ("Scripts/main.lua: run_public_report_opportunity", ["config.runtime.report_refresh_interval_seconds", "config.reports.*"], "docs/SOURCE_MODULE_REFERENCE.md#public-reporting-module"),
    "world_state": ("Scripts/main.lua: world-state snapshot writers", ["config.world_state.*", "config.scanning.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "scan": ("Scripts/main.lua: begin/continue/finish scan job", ["config.saved.*", "config.scanning.*", "config.source_accounting.changed_file_manifest"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "object_registry": ("Scripts/main.lua: scan output and object registry writers", ["config.object_registry.*", "config.class_categories.*", "config.high_risk_classes.*", "config.accumulation.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "enforcement": ("Scripts/main.lua: Admin.ini parser/evaluate_enforcement/append_ban", ["config.enforcement.*", "config.admin_ini.*", "config.whitelist", "config.restart_request.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "forensic": ("Scripts/main.lua: forensic/daily/weekly summary writers", ["config.forensic_rollup.*", "config.retention.*", "config.warning_report.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "log_tail": ("Scripts/main.lua: log registry, tail, cursor commit, and continuity writers", ["config.log_tail.*", "config.logging.*", "config.runtime.max_*", "config.retention.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "account_review": ("Scripts/main.lua: account/session/warning/case writers", ["config.warning_bursts.*", "config.join_leave.*", "config.raid_detection.*", "config.warning_report.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "lifecycle": ("Scripts/main.lua: epoch/lifecycle/crash-correlation writers", ["config.server_lifecycle.*", "config.crash_correlation.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "restart": ("Scripts/main.lua: verified-ban restart marker writer", ["config.restart_request.*", "config.enforcement.request_restart_after_ban"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "saved_discovery": ("Scripts/main.lua: derive_saved_candidates/find_saved_root", ["config.saved.*", "RandomDayGuard/SavedRoot.txt"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "runtime_status": ("Scripts/main.lua: bootstrap, startup, poll, and scheduler status writers", ["config.enabled", "config.runtime.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "evidence": ("Scripts/main.lua: normalized evidence writers", ["config.logging.*", "config.retention.*"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
    "runtime_state": ("Scripts/main.lua: owning runtime state writer", ["owning `config.*` section in CONFIG_FIELD_CATALOG.md"], "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory"),
}


EXACT_OUTPUT_META = {
    "runtime/current/**": (
        "Scripts/main.lua: current poll/session/forensic/context state writers",
        ["config.runtime.*", "config.forensic_rollup.write_current_today", "config.world_state.*", "config.warning_report.*"],
        "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory",
    ),
    "runtime/current/actor_touch_rollup.json": (
        "Scripts/main.lua: record_actor_touch/write_actor_touch_rollup",
        ["config.logging.max_actor_touch_events_per_poll", "config.logging.max_actor_touch_events_per_session", "config.logging.escalate_low_to_medium_when_correlated"],
        "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory",
    ),
    "runtime/current/spatial_context.json": (
        "Scripts/main.lua: target-context/spatial-context writer",
        ["config.target_context.*", "config.accumulation.require_target_context_for_enforcement"],
        "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory",
    ),
    "runtime/final_logs/**": (
        "Scripts/main.lua: forensic final-log writers; Scripts/public_pipeline.lua: route/accounting writers",
        ["config.forensic_rollup.final_log_root", "config.reports.output_root", "config.source_accounting.*"],
        "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory",
    ),
    "runtime/playerdata_index.json": (
        "Scripts/main.lua: Saved scan and PlayerData identity-index writer",
        ["config.saved.scan_player_data", "config.scanning.*", "config.enforcement.require_playerdata_verified"],
        "docs/OUTPUT_SCHEMA_REFERENCE.md#runtime-output-inventory",
    ),
}


def generated_purpose(path: str, family: str) -> str:
    if path in OUTPUT_PURPOSES:
        return OUTPUT_PURPOSES[path]
    match = re.fullmatch(r"runtime/final_logs/(server_status|daily_rollup|player_activity|case_review|critical_guard)_latest\.(json|txt)", path)
    if match:
        route, suffix = match.groups()
        form = "structured" if suffix == "json" else "operator-readable translated"
        return f"Latest {form} {words(route)} route report."
    if path.endswith("/**"):
        return f"Dynamic output class containing {words(path.removeprefix('runtime/').removesuffix('/**'))} state owned by {words(family)}."
    if "*_latest.json" in path:
        return "Dynamic latest local-outbox envelope class, one file per configured proven route."
    if "enforcement_failed_*" in path:
        return "Per-attempt structured fail-closed enforcement evidence class."
    if "warning_*" in path:
        return "Rotated per-period/per-player warning report class."
    if "world_state_boot_*" in path:
        return "Per-boot world-state context snapshot class."
    if path.endswith(".jsonl"):
        return f"Append-only {words(Path(path).stem)} ledger."
    if path.endswith(".tsv"):
        return f"Tabular {words(Path(path).stem)} state/index."
    if path.endswith(".json"):
        return f"Structured {words(Path(path).stem)} state document."
    if path.endswith(".txt"):
        return f"Operator-readable {words(Path(path).stem)} record."
    return f"Local {words(path.removeprefix('runtime/'))} state owned by {words(family)}."


def generated_side_effect(path: str, family: str) -> str:
    if family == "notification":
        return "Atomically replaces local outbox/status JSON only; no provider send or network action exists."
    if family == "route_report":
        return "Atomically replaces one JSON/TXT route pair; proof is committed separately after all route writes."
    if path.endswith(".jsonl"):
        return "Appends one bounded structured record; retention/rotation may archive rebuildable history."
    if path.endswith("/**"):
        return "Creates owner-specific files below this runtime directory class; no packaged evidence is modified."
    if path == "runtime/request_restart.flag":
        return "Creates/replaces a local marker only; it does not restart, kill, deploy, or call a provider."
    if family == "enforcement" and ("Admin_" in path or "enforced" in path):
        return "Writes a backup or enforcement audit record; Admin.ini mutation occurs only in append_ban after all gates."
    return "Atomically replaces or writes this local runtime state through the owning source block."


def generated_states(family: str) -> list[str]:
    if family == "route_report":
        return ["route proof: full", "route proof: limited_expected_empty", "route proof: missing"]
    if family in {"public_contract", "notification"}:
        return ["top-level truth: complete/complete_with_gaps/partial/unavailable", "source detail may be deferred/error", "route proof remains full/limited_expected_empty/missing"]
    if family in {"scan", "saved_discovery", "log_tail", "evidence"}:
        return ["source-level available/expected_empty/partial/deferred/unavailable", "source-level malformed/permission_denied/error", "never implicit route success"]
    return ["present and current", "present with an explicit owner error/incomplete state", "missing or stale"]


def generated_failure(path: str, family: str) -> str:
    if family == "route_report":
        return f"Missing, stale, or unpaired `{path}` forces that route to missing and blocks notification eligibility."
    if family == "notification":
        return f"A failed `{path}` write proves no local queue completion and never proves external delivery."
    if family == "scan":
        return f"Missing/stale `{path}` leaves scan coverage partial, deferred, unavailable, or failed; it cannot prove expected-empty."
    if family == "enforcement":
        return f"Failure to write/read `{path}` records or preserves fail-closed state; no successful mutation may be inferred."
    return f"Missing, stale, malformed, or failed `{path}` cannot prove its owner completed or its evidence is current."


def generated_recovery(path: str, family: str) -> str:
    actions = {
        "route_report": "repair source lineage and both route writes, then regenerate route_proof.json for the same cycle",
        "public_contract": "repair the named source/accounting/proof write and regenerate all current-cycle contract files",
        "notification": "repair the local outbox path and regenerate only from a proven current route",
        "report_worker": "repair the recorded report worker error and allow the next bounded between-polls opportunity",
        "scan": "repair Saved discovery/read/write input and resume the checkpoint or start a reviewed baseline",
        "object_registry": "repair the scan/pattern input and rebuild partial/final registry outputs",
        "enforcement": "return to review-only, verify the Admin.ini backup state, read the recorded reason, and correct that check",
        "forensic": "repair retained evidence/output paths and rebuild the affected index window",
        "log_tail": "repair the active log/cursor write and replay only from the last durable offset",
        "account_review": "repair mapped source/session evidence and rebuild the affected account/case report",
        "lifecycle": "repair lifecycle source continuity and begin/reconcile the correct server epoch",
        "restart": "verify the ban first, repair the local marker path, and verify any external consumer separately",
        "saved_discovery": "correct SavedRoot/candidates and rerun the readable-file probe",
        "runtime_status": "repair the recorded startup/poll owner and generate a newer current status",
        "evidence": "repair the source/write path and replay from authoritative retained evidence",
        "world_state": "repair scan/write input and regenerate the relevant snapshot without claiming ownership",
        "runtime_state": "repair the owning source/write path and generate a newer owner state",
    }
    return f"For `{path}`, {actions[family]}."


def packaged_entry(path: str) -> dict[str, object]:
    purpose, owner, settings, side_effect, failure, recovery = PACKAGED_META[path]
    return {
        "path": path,
        "kind": "packaged source/configuration/data member",
        "purpose": purpose,
        "owning_source": owner,
        "inputs": ["tracked reviewed source bytes"],
        "outputs": ["installed " + path],
        "public_settings": settings,
        "side_effects": [side_effect],
        "operator_visible_states": ["present and version-aligned", "missing, invalid, or divergent"],
        "failure_modes": [failure],
        "recovery": [recovery],
        "canonical_document": "docs/SOURCE_MODULE_REFERENCE.md#packaged-file-map" if "main.lua" not in path and "public_pipeline" not in path else (
            "docs/SOURCE_MODULE_REFERENCE.md#public-reporting-module" if "public_pipeline" in path else "docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog"
        ),
        "user_editable": path in {"RandomDayGuard/config.lua", "RandomDayGuard/SavedRoot.txt"},
        "packaged_or_generated": "packaged",
    }


def generated_entry(path: str) -> dict[str, object]:
    family = output_family(path)
    owner, settings, document = EXACT_OUTPUT_META.get(path, FAMILY_META[family])
    return {
        "path": path,
        "kind": "generated local output or dynamic path class",
        "purpose": generated_purpose(path, family),
        "owning_source": owner,
        "inputs": ["current owner state and explicitly cited server-owned/local evidence"],
        "outputs": [path],
        "public_settings": settings,
        "side_effects": [generated_side_effect(path, family)],
        "operator_visible_states": generated_states(family),
        "failure_modes": [generated_failure(path, family)],
        "recovery": [generated_recovery(path, family)],
        "canonical_document": document,
        "user_editable": False,
        "packaged_or_generated": "generated",
    }


def render_traceability(packaged_paths: Iterable[str], generated_paths: Iterable[str]) -> str:
    entries = [packaged_entry(path) for path in sorted(packaged_paths)]
    entries.extend(generated_entry(path) for path in sorted(generated_paths))
    payload = {
        "schema": "randomdayguard.traceability/v2",
        "generator": "tools/generate_documentation_audit.py",
        "entries": entries,
    }
    return json.dumps(payload, indent=2, sort_keys=True, ensure_ascii=True) + "\n"


def build_outputs(
    config_table: tuple[dict[str, object], list[object]],
    packaged_paths: Iterable[str],
    generated_paths: Iterable[str],
) -> dict[Path, str]:
    return {
        CATALOG_PATH: render_catalog(config_table),
        TRACEABILITY_PATH: render_traceability(packaged_paths, generated_paths),
    }


def validator_inputs() -> tuple[tuple[dict[str, object], list[object]], set[str], set[str]]:
    sys.path.insert(0, str(ROOT / "tools"))
    import validate_repo as validator

    config_table = validator.parse_config_table(validator.text(validator.MOD / "config.lua"))
    packaged = {
        *(f"RandomDayGuard/{relative}" for relative in validator.CANDIDATE_DIRECT_PATHS),
        "RandomDayGuard/Scripts/main.lua",
        "RandomDayGuard/runtime/**/.gitkeep",
    }
    return config_table, packaged, validator.generated_output_paths()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate/check public config and traceability audit docs")
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true", help="write deterministic generated docs")
    mode.add_argument("--check", action="store_true", help="check generated docs are current")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    config_table, packaged, generated = validator_inputs()
    outputs = build_outputs(config_table, packaged, generated)
    stale: list[str] = []
    for path, content in outputs.items():
        if args.write:
            path.write_text(content, encoding="utf-8", newline="\n")
        elif not path.is_file() or path.read_text(encoding="utf-8") != content:
            stale.append(path.relative_to(ROOT).as_posix())
    if stale:
        print("DOCUMENTATION AUDIT GENERATION CHECK FAILED")
        for path in stale:
            print(f"- stale generated file: {path}")
        return 1
    action = "WROTE" if args.write else "CHECK PASSED"
    print(f"DOCUMENTATION AUDIT {action}: {len(flatten_config(config_table))} config leaves, {len(packaged)} packaged rows, {len(generated)} generated rows")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
