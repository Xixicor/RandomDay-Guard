#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MOD = ROOT / "RandomDayGuard"
VERSION = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
ZIP_PATH = ROOT / "releases" / VERSION / f"RandomDayGuard_{VERSION}.zip"

REQUIRED_REPO_FILES = [
    "README.md",
    "INSTALL.md",
    "CHANGELOG.md",
    "VERSION",
    "LICENSE",
    "RandomDayGuard/enabled.txt",
    "RandomDayGuard/config.lua",
    "RandomDayGuard/SavedRoot.txt",
    "RandomDayGuard/BUILD_MARKER.txt",
    "RandomDayGuard/README.txt",
    "RandomDayGuard/MANIFEST.json",
    "RandomDayGuard/Scripts/main.lua",
    "RandomDayGuard/scripts/main.lua",
    "RandomDayGuard/data/detection_events.json",
    "RandomDayGuard/data/warning_types.json",
    "RandomDayGuard/data/object_categories.json",
    "docs/ARCHITECTURE.md",
    "docs/CONFIG_REFERENCE.md",
    "docs/EVIDENCE_BOUNDARY.md",
    "docs/BAN_ID_MAPPING.md",
    "docs/HOSTINGER_AMP_INSTALL.md",
    "docs/WORLD_SAVE_FOLDER_CHANGES.md",
    "docs/OPERATIONS_PLAYBOOK.md",
    "tools/build_release_zip.py",
    "tools/validate_repo.py",
]

REQUIRED_ZIP = [
    "RandomDayGuard/enabled.txt",
    "RandomDayGuard/config.lua",
    "RandomDayGuard/SavedRoot.txt",
    "RandomDayGuard/BUILD_MARKER.txt",
    "RandomDayGuard/README.txt",
    "RandomDayGuard/MANIFEST.json",
    "RandomDayGuard/Scripts/main.lua",
    "RandomDayGuard/scripts/main.lua",
    "RandomDayGuard/data/detection_events.json",
    "RandomDayGuard/data/warning_types.json",
    "RandomDayGuard/data/object_categories.json",
    "RandomDayGuard/runtime/.gitkeep",
    "RandomDayGuard/runtime/backups/.gitkeep",
    "RandomDayGuard/runtime/baselines/.gitkeep",
    "RandomDayGuard/runtime/current/.gitkeep",
    "RandomDayGuard/runtime/days/.gitkeep",
    "RandomDayGuard/runtime/forensic_days/.gitkeep",
    "RandomDayGuard/runtime/final_logs/.gitkeep",
    "RandomDayGuard/runtime/evidence/.gitkeep",
    "RandomDayGuard/runtime/epochs/.gitkeep",
    "RandomDayGuard/runtime/logs/.gitkeep",
    "RandomDayGuard/runtime/raid_cases/.gitkeep",
    "RandomDayGuard/runtime/sessions/.gitkeep",
    "RandomDayGuard/runtime/warnings/.gitkeep",
    "RandomDayGuard/runtime/world_state/.gitkeep",
    "RandomDayGuard/runtime/world_state/boot/.gitkeep",
    "RandomDayGuard/runtime/world_state/current/.gitkeep",
    "RandomDayGuard/runtime/world_state/sessions/.gitkeep",
]

ALLOWED_RUNTIME_KEEP = {name.removeprefix("RandomDayGuard/") for name in REQUIRED_ZIP if "/runtime/" in name}

PRIVATE_PATTERNS = [
    r"7656119\d{10}",
    r"00023493120e4823b0fa2371a1aaecf0",
    r"Sypher",
    r"Velociwaptors",
    r"\bAxtlan\b",
    r"/mnt/data",
    r"incident[-_ ](?:name|id|case|evidence)",
]

FORBIDDEN_ZIP_NAMES = [
    r"rdg_core",
    r"guard_.*\.lua$",
    r"BOOT_MAIN_EXECUTED",
    r"BUILD_RUNNING_VERSION",
    r"THIS_IS_.*COMPLETE_BUILD",
    r"BOOT_FROM_MAIN",
    r"\.randomdayguard_version",
    r"v0\.2",
    r"diagnostic",
]

UNAVAILABLE_CLAIMS = [
    r"\bdetects? object damage\b",
    r"\bdetects? container use\b",
    r"\bdetects? item duplication\b",
    r"\bexact player coordinates\b.*\bimplemented\b",
    r"\blive ping\b.*\bimplemented\b",
    r"\bobject ownership\b.*\bimplemented\b",
]

ADMIN_BAD_EXAMPLES = [
    r"BannedPlayer=.*[#;]",
    r"BannedPlayer=.*reason",
    r"BannedPlayer=.*http",
    r"BannedPlayer=.*_\+_\|",
]


def text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def add(errors: list[str], message: str) -> None:
    errors.append(message)


def validate_lua_parse(errors: list[str]) -> None:
    main_path = MOD / "Scripts" / "main.lua"
    luac = shutil.which("luac")
    lua = shutil.which("lua")
    if luac:
        result = subprocess.run([luac, "-p", str(main_path)], cwd=ROOT, text=True, capture_output=True)
        if result.returncode != 0:
            add(errors, "main.lua has Lua syntax errors: " + (result.stderr or result.stdout).strip())
        return
    if lua:
        result = subprocess.run([lua, "-e", f"assert(loadfile({str(main_path)!r}))"], cwd=ROOT, text=True, capture_output=True)
        if result.returncode != 0:
            add(errors, "main.lua has Lua syntax errors: " + (result.stderr or result.stdout).strip())
        return

    # Keep a small fallback so CI without Lua still catches the observed
    # regression class, but prefer luac/lua whenever available.
    main = text(main_path)
    if re.search(r"for\s+_,f\s+in\s+ipairs\(files\)\s+do\s+by_rel\[f\.relpath\]\s*=\s*f\s+end\s+end", main):
        add(errors, "main.lua has Lua syntax errors: duplicate end in probe_saved_root readable-file map")


def validate_required(errors: list[str]) -> None:
    for rel in REQUIRED_REPO_FILES:
        if not (ROOT / rel).exists():
            add(errors, f"missing required path: {rel}")
    if VERSION != "v0.4.11-alpha":
        add(errors, "VERSION is not v0.4.11-alpha")
    releases = ROOT / "releases"
    if releases.exists():
        for child in releases.iterdir():
            if child.is_dir() and child.name != VERSION:
                add(errors, f"obsolete release folder remains: releases/{child.name}")


def validate_versions(errors: list[str]) -> None:
    cfg = text(MOD / "config.lua")
    main = text(MOD / "Scripts" / "main.lua")
    lower_main = MOD / "scripts" / "main.lua"
    if not lower_main.exists():
        add(errors, "lowercase UE4SS scripts/main.lua is missing")
    elif lower_main.read_bytes() != (MOD / "Scripts" / "main.lua").read_bytes():
        add(errors, "RandomDayGuard/Scripts/main.lua and RandomDayGuard/scripts/main.lua differ")
    main_match = re.search(r'local\s+VERSION\s*=\s*"([^"]+)"', main)
    main_version = main_match.group(1) if main_match else None
    if main_version != VERSION:
        add(errors, "VERSION and main.lua local VERSION differ")
    match = re.search(r'version\s*=\s*"([^"]+)"', cfg)
    if not match or match.group(1) != VERSION:
        add(errors, "config version and VERSION disagree")
    if main_version and match and match.group(1) != main_version:
        add(errors, "config.lua version and main.lua local VERSION differ")
    if VERSION not in text(MOD / "BUILD_MARKER.txt"):
        add(errors, "build marker/version disagree")
    if main_version and main_version not in text(MOD / "BUILD_MARKER.txt"):
        add(errors, "BUILD_MARKER version and main.lua local VERSION differ")
    manifest = json.loads(text(MOD / "MANIFEST.json"))
    if manifest.get("version") != VERSION:
        add(errors, "MANIFEST.json version and VERSION disagree")
    if main_version and manifest.get("version") != main_version:
        add(errors, "MANIFEST.json version and main.lua local VERSION differ")


def validate_runtime(errors: list[str]) -> None:
    main = text(MOD / "Scripts" / "main.lua")
    if VERSION != "v0.4.11-alpha":
        add(errors, "VERSION changed away from v0.4.11-alpha during stabilization")
    if (ROOT / "releases" / "v0.4.12-alpha").exists():
        add(errors, "v0.4.12 release folder was created during v0.4.11 stabilization")
    if re.search(r"\brequire\s*[\(\"]", main):
        add(errors, "main.lua has an external Lua require dependency")
    required_terms = [
        "startup_status.json",
        "runtime_capabilities.json",
        "saved_path_probe.json",
        "scan_started.json",
        "scan_complete.json",
        "scan_checkpoint.json",
        "logs/current.jsonl",
        "object_registry.json",
        "object_registry_partial.json",
        "object_registry_counts.tsv",
        "object_registry_counts_partial.tsv",
        "new_classes_detected.jsonl",
        "baselines/last_scan.json",
        "baselines/file_manifest.tsv",
        "baselines/last_completed_baseline.json",
        "account_evidence.json",
        "account_evidence.tsv",
        "session_events.tsv",
        "raw_events.jsonl",
        "warning_events",
        "world_state/sessions",
        "world_state/boot",
        "world_state/current/world_state_latest.json",
        "raid_cases/index.jsonl",
        "ban_queue.json",
        "enforced_bans.jsonl",
        "request_restart.flag",
        "restart_reason.json",
        "log_registry.json",
        "log_continuity_events.jsonl",
        "server_lifecycle_events.jsonl",
        "server_epochs.jsonl",
        "current_server_epoch.json",
        "loader_probe.json",
        "loader_probe.txt",
        "loader_probe_root.txt",
        "admin_state.json",
        "playerdata_index.json",
        "runtime/weeks/",
        "runtime/current/session_state.json",
        "runtime/current/spatial_context.json",
        "runtime/current/actor_touch_rollup.json",
        "runtime/current/active_accounts.json",
        "runtime/current/poll_status.json",
        "runtime/evidence/session_events.jsonl",
        "runtime/evidence/medium_events.jsonl",
        "runtime/evidence/high_events.jsonl",
        "runtime/evidence/critical_events.jsonl",
        "runtime/evidence/enforced_bans.jsonl",
        "runtime/evidence/lifecycle_events.jsonl",
        "runtime/evidence/log_continuity_events.jsonl",
        "runtime/sessions/",
        "runtime/epochs/",
        "runtime/days/",
        "runtime/runtime_version.json",
    ]
    for term in required_terms:
        if term not in main:
            add(errors, f"main.lua missing required output reference: {term}")
    runtime_required = [
        "local function all_saved_files",
        "all_saved_files(state.saved_root)",
        "local function initialize_log_tail",
        "initialize_log_tail()",
        "parse_login_request",
        "ConnectID",
        "UniqueId",
        "connect_id_raw",
        "raw_id",
        "local function clean_ban_id",
        "match(\"^(%d+)\")",
        "find_playerdata_file",
        "playerdata_verified",
        "identity_confidence",
        "poll_status.json",
        "IDENTITY_STRENGTH",
        "merge_account_identity",
        "log_file_fingerprint",
        "detect_log_rotation_or_truncation",
        "duplicate_suppressed",
        "start_epoch",
        "close_active_sessions_for_lifecycle",
        "Server lifecycle context",
        "local function write_loader_probe",
        "xpcall(start",
        "config_load_error.txt",
        "local function poll_once",
        "local function safe_poll_once",
        "local function schedule_next_poll",
        "function start_poll_loop",
        "local function stop_poll_loop",
        "LoopAsync(interval",
        "pcall(function()",
        "_G.RandomDayGuard_Poll",
        "_G.RandomDayGuard_WeeklySummary",
        "BOOTSTRAP_REACHED.txt",
        "rotate_if_needed",
        "bounded_recent_event_keys_add",
        "generate_weekly_summary",
        "run_retention_cleanup",
        "post_write_verification_failed",
        "write_admin_state",
        "write_playerdata_index",
        "WORLD_ACTOR_SAVE_TOUCH",
        "handle_actor_touch",
        "actor_touch_rollups",
        "write_session_summary",
        "write_epoch_summary",
        "write_daily_summary",
        "append_compact_event",
        "append_bounded_raw_event",
        "low_importance_mode",
        "runtime_ready",
        "write_minimal_current_state",
        "ready_degraded",
        "startup_deferred",
        "poll_scheduled",
        "poll_in_flight",
        "clean_presence_name",
        "canonical_log_key",
        "tail_backup_logs ~= true",
        "backfill_active_log_on_boot",
        "poll_stage",
        "log_backlog_pending",
        "budget_exhausted",
        "lines_processed_this_poll",
        "bytes_processed_this_poll",
        "current_log_file",
        "max_log_files_per_poll",
        "state.scan_job",
        "begin_scan_job",
        "continue_scan_job",
        "finish_scan_job",
        "write_scan_progress",
        "scan_job_active",
        "scan_phase",
        "scan_files_done",
        "scan_total_files",
    ]
    for term in runtime_required:
        if term not in main:
            add(errors, f"runtime/source check missing: {term}")
    runtime_path_pos = main.find("runtime_path = function")
    loader_probe_pos = main.find("local function write_loader_probe")
    loader_runtime_call_pos = main.find('runtime_path("runtime/loader_probe', loader_probe_pos)
    root_bootstrap_pos = main.find("BOOTSTRAP_REACHED.txt", loader_probe_pos)
    root_probe_pos = main.find("loader_probe_root.txt", loader_probe_pos)
    if runtime_path_pos == -1 or loader_probe_pos == -1 or runtime_path_pos > loader_probe_pos:
        add(errors, "write_loader_probe can call runtime_path before runtime_path exists")
    if root_bootstrap_pos == -1 or root_probe_pos == -1 or loader_runtime_call_pos == -1:
        add(errors, "write_loader_probe missing root fallback or runtime probe writes")
    elif root_bootstrap_pos > loader_runtime_call_pos or root_probe_pos > loader_runtime_call_pos:
        add(errors, "write_loader_probe uses runtime_path before root fallback diagnostics")
    loader_block = main[loader_probe_pos:main.find("local function sanitize_filename", loader_probe_pos)]
    if "pcall(function()" not in loader_block:
        add(errors, "write_loader_probe writes are not protected by pcall")
    if re.search(r"if #files == 0.*direct", main, flags=re.IGNORECASE | re.DOTALL):
        add(errors, "direct fallback files appear to be used only when list_files returns zero")
    simple_hash_block = main.split("local function simple_hash", 1)[1].split("local function", 1)[0] if "local function simple_hash" in main else ""
    if "~" in simple_hash_block or "&" in simple_hash_block:
        add(errors, "simple_hash uses Lua 5.3 bitwise syntax")
    if re.search(r"(?<![A-Za-z0-9_])(~(?!=)|<<|>>)(?![A-Za-z0-9_])", main):
        add(errors, "main.lua contains unguarded Lua 5.3 bitwise operators")
    if re.search(r"table\.insert\s*\([^)\n]*:[ \t]*(?:gsub|match)\s*\(", main):
        add(errors, "table.insert receives direct gsub/match multi-return expression")
    if re.search(r"table\.insert\s*\([^)\n]*\bmatch\s*\([^)]*,[^)]*,", main):
        add(errors, "table.insert receives possible multi-capture match expression")
    if "raw and normalize_account_id(raw) or mapped_presence(name)" in main:
        add(errors, "join handling still uses unsafe raw and/or mapped_presence expression")
    if "playerdata_verified == true" not in main:
        add(errors, "PlayerData verified=true preservation is missing")
    if "lifecycle_close" not in main or "epoch_id" not in main:
        add(errors, "session records lack lifecycle boundary fields")
    apply_block = main.split("local function apply_event", 1)[1] if "local function apply_event" in main else main
    lifecycle_block = apply_block.split('ev.type == "SERVER_LIFECYCLE_EVENT"', 1)[1].split('elseif ev.type == "DEPLOYABLE_WARNING_BURST"', 1)[0] if 'ev.type == "SERVER_LIFECYCLE_EVENT"' in apply_block else ""
    if "add_warning" in lifecycle_block:
        add(errors, "server lifecycle events appear to increment account warning score")
    if "lifecycle_only" in main and "BAN-ELIGIBLE" in main:
        add(errors, "lifecycle-only events may create BAN-ELIGIBLE status")
    log_fn = main.split("local function log_files", 1)[1].split("local function", 1)[0] if "local function log_files" in main else ""
    if "list_files(join_path(state.saved_root, \"Logs\"))" in log_fn or "list_files(join_path(state.saved_root, 'Logs'))" in log_fn:
        add(errors, "log_files relies on list_files(saved_root/Logs)")
    if 'log_tail_status = "not_started"' in main and "initialize_log_tail()" not in main:
        add(errors, "startup can leave log_tail_status not_started")
    if "BannedPlayer=" not in main:
        add(errors, "main.lua missing clean BannedPlayer=<ID> writer")
    start_block = main.split("local function start()", 1)[1].split("local function poll_once", 1)[0] if "local function start()" in main else ""
    if "startup_scan(" in start_block:
        add(errors, "start() calls startup_scan before start_poll_loop")
    for phase in ["starting", "config_loaded", "saved_root_found", "log_tail_initialized", "epoch_started", "admin_state_written", "playerdata_index_written", "watchdog_started", "ready_degraded", "scan_running", "ready", "scan_failed"]:
        if phase not in main:
            add(errors, f"startup_status phase missing: {phase}")
    if "write_minimal_current_state(true)" not in start_block:
        add(errors, "current-state placeholder writers are missing from startup")
    if "phase=\"boot_marker\"" in main or 'phase="boot_marker"' in main:
        add(errors, "boot can remain only phase=boot_marker")
    schedule_block = main.split("local function schedule_next_poll", 1)[1].split("function start_poll_loop", 1)[0] if "local function schedule_next_poll" in main else ""
    if "schedule_next_poll()" not in schedule_block or "state.poll_scheduled" not in schedule_block:
        add(errors, "LoopAsync callback does not reschedule or poll_scheduled is missing")
    if "state.poll_in_flight" not in main or "skipped_poll_count" not in main:
        add(errors, "poll_in_flight/skipped poll status is missing")
    registry_block = main.split("local function update_log_registry", 1)[1].split("local function write_poll_status", 1)[0] if "local function update_log_registry" in main else ""
    if "not state.initializing_logs" not in registry_block:
        add(errors, "backup log first_seen can start a new epoch during initialize_log_tail")
    if "state.initializing_logs = true" not in main:
        add(errors, "initial log discovery can create many epochs before startup ready")
    if "clean_presence_name" not in main or "LogAbiotic_Display_CHAT_LOG_" not in main or "CHAT LOG:%s*(.-)%s+has entered the facility" not in main:
        add(errors, "CHAT LOG prefix stripping or presence-name cleanup is missing")
    if "state.recent_logins[ev.log_name]" not in main:
        add(errors, "recent login mapping is missing")
    if "runtime_version.json" not in main or "ignore_old_boot_ids" not in main:
        add(errors, "runtime_version.json writer or current boot filter is missing")
    if "UPDATE_ACTOR_SAVE_WARNING_BURST" in main:
        add(errors, "old UPDATE_ACTOR_SAVE_WARNING_BURST can appear in current outputs")
    if "local function canonical_log_key" not in main or 'path:match("^z:/")' not in main:
        add(errors, "no canonical_log_key function or Wine Z: alias stripping")
    if "local function log_file_key(path) return canonical_log_key(path) end" not in main:
        add(errors, "log registry does not use canonical log key")
    if "offsets[key]" not in main or "canonical_log_key(path)" not in main:
        add(errors, "log_offsets uses raw path instead of canonical key")
    if "tail_backup_logs ~= true" not in main:
        add(errors, "backup logs can be tailed during live poll by default")
    if re.search(r'line:find\("LogInit"', main):
        add(errors, "generic LogInit detail lines create SERVER_LIFECYCLE_EVENT")
    if "max_lines" not in main or "max_bytes" not in main or "budget_exhausted" not in main:
        add(errors, "poll loops can process unlimited logs/files in one poll")
    if "state.poll_in_flight = false" not in main:
        add(errors, "poll_in_flight can remain true after budget exhaustion")
    poll_block = main.split("local function poll_once", 1)[1].split("local function safe_poll_once", 1)[0] if "local function poll_once" in main else ""
    def fn_block(name: str, next_name: str | None = None) -> str:
        marker = f"local function {name}"
        if marker not in main:
            return ""
        block = main.split(marker, 1)[1]
        if next_name:
            next_marker = f"local function {next_name}"
            if next_marker in block:
                block = block.split(next_marker, 1)[0]
        return block

    live_blocks = {
        "probe_saved_root": fn_block("probe_saved_root", "find_saved_root"),
        "find_saved_root": fn_block("find_saved_root", "should_scan_file"),
        "log_files": fn_block("log_files", "refresh_log_file_cache"),
        "update_log_registry": fn_block("update_log_registry", "write_poll_status"),
        "write_poll_status": fn_block("write_poll_status", "initialize_log_tail"),
        "begin_scan_job": fn_block("begin_scan_job", "finish_scan_job"),
        "continue_scan_job": fn_block("continue_scan_job", "start"),
        "safe_poll_once": fn_block("safe_poll_once", "schedule_next_poll"),
    }
    for name, block in live_blocks.items():
        if "all_saved_files(" in block:
            add(errors, f"{name} reaches full Saved discovery through all_saved_files")
        if "list_files(" in block:
            add(errors, f"{name} reaches recursive listing through list_files")
        if "io.popen" in block:
            add(errors, f"{name} contains shell popen discovery")
        if "cmd /c dir" in block:
            add(errors, f"{name} contains cmd recursive directory discovery")
        if 'startup_scan("' in block:
            add(errors, f"{name} calls startup_scan from a live runtime path")
    if "log_files()" in live_blocks["write_poll_status"]:
        add(errors, "write_poll_status calls log discovery instead of cached state")
    if "log_files()" in live_blocks["update_log_registry"]:
        add(errors, "update_log_registry calls log discovery instead of cached log paths")
    if "unique_log_paths" not in main:
        add(errors, "unique_log_paths helper is missing")
    if "unique_log_paths(out)" not in main or "unique_log_paths(cached_log_file_paths())" not in main:
        add(errors, "cached/update log paths are not canonical-deduped")
    if any(term in live_blocks["probe_saved_root"] for term in ["list_files(", "all_saved_files(", "io.popen", "cmd /c dir"]):
        add(errors, "probe_saved_root enumerates full candidate roots")
    if any(term in live_blocks["find_saved_root"] for term in ["list_files(", "all_saved_files(", "io.popen", "cmd /c dir"]):
        add(errors, "find_saved_root enumerates full candidate roots")
    for term in ["run_retention_cleanup()", "write_daily_summary(\"scheduled\")", "generate_weekly_summary(\"scheduled\")", "rebuild_warning_report(true)"]:
        if term in poll_block:
            add(errors, f"poll_once can run unbounded maintenance/report work: {term}")
    if "report_deferred" not in poll_block or "cleanup_deferred" not in poll_block or "weekly_summary_deferred" not in poll_block:
        add(errors, "poll_once does not defer report/cleanup/weekly maintenance status")
    if "state.scan_job = job" not in live_blocks["begin_scan_job"] or "all_saved_files" in live_blocks["begin_scan_job"]:
        add(errors, "begin_scan_job does not initialize only, or still enumerates Saved")
    tail_block = fn_block("tail_logs", "startup_scan")
    if "unique_log_paths(files)" not in tail_block or "tail_files_seen" not in tail_block or "tail_files_unique" not in tail_block:
        add(errors, "tail_logs does not dedupe canonical log paths before tail budget accounting")
    if "active_log_caught_up" not in tail_block or "active_log_unread_bytes" not in tail_block or "active_log_read_failed" not in tail_block or "log_backlog_reason" not in tail_block:
        add(errors, "tail_logs does not compute explicit active-log backlog status")
    if "state.log_backlog_pending = active_log_read_failed or (budget_exhausted and active_log_unread_bytes > 0) or active_log_unread_bytes > 0" not in tail_block:
        add(errors, "tail_logs does not clear false backlog when active log is caught up")
    if "prior_poll_completed" not in poll_block or "state.poll_completed_count" not in main or "state.last_poll_completed_ts" not in main:
        add(errors, "startup deferred scan does not require a completed prior poll")
    if "state.active_log_caught_up == true" not in poll_block or "(state.active_log_unread_bytes or 0) == 0" not in poll_block:
        add(errors, "startup scan gate does not require active log caught up with zero unread bytes")
    for term in ["active_log_unique_count", "active_log_duplicate_count", "tail_files_seen", "tail_files_unique", "active_log_caught_up", "active_log_unread_bytes", "active_log_read_failed", "active_log_size", "active_log_offset", "active_log_key", "log_backlog_reason", "startup_scan_gate"]:
        if term not in main:
            add(errors, f"poll_status/startup scan gate missing: {term}")
    apply_event_prefix = main.split("local function apply_event", 1)[1].split("append_compact_event(ev)", 1)[0] if "local function apply_event" in main and "append_compact_event(ev)" in main else ""
    if "resolve_presence_event_identity(ev)" not in apply_event_prefix:
        add(errors, "PLAYER_JOIN_STATE is not re-resolved before event evidence is appended/applied")
    if 'type="log_seen"' in main or "type='log_seen'" in main:
        add(errors, "log_seen continuity events can still be appended every poll")
    if "if state.startup_scan_pending == true and" in poll_block:
        add(errors, "startup_scan_pending branch can fall through into periodic_refresh scan")
    if 'startup_scan("periodic_refresh")' in poll_block and 'elseif scan_due and reason ~= "startup" then' not in poll_block:
        add(errors, "startup_scan(\"periodic_refresh\") can run while startup_scan_pending == true")
    if 'write_json(runtime_path("runtime/scan_progress.json")' not in main or 'poll_id=state.poll_id' not in main:
        add(errors, "scan_progress.json is not written with poll_id before startup_deferred scan")
    if "startup_scan_waiting" not in poll_block or "deferred_scan_waiting" not in poll_block:
        add(errors, "poll_stage startup_scan_waiting or deferred wait status is missing")
    if 'startup_scan("startup_deferred")' in poll_block:
        add(errors, 'poll_once contains startup_scan("startup_deferred")')
    if 'startup_scan("periodic_refresh")' in poll_block:
        add(errors, 'poll_once contains startup_scan("periodic_refresh")')
    if "begin_scan_job(\"startup_deferred\")" not in poll_block or "begin_scan_job(\"periodic_refresh\")" not in poll_block:
        add(errors, "poll loop does not start incremental scan jobs")
    if "continue_scan_job()" not in poll_block:
        add(errors, "active scan job is not continued from poll loop")
    if "scan_job_active" not in main or "scan_phase" not in main or "scan_files_done" not in main or "scan_total_files" not in main:
        add(errors, "scan job state is missing from poll_status")
    if "startup_scan_max_bytes_per_tick" not in main or "startup_scan_files_per_tick" not in main:
        add(errors, "incremental scan budgets are missing")
    for term in ["discover_direct_known", "discover_recursive", "continue_scan_recursive_discovery", "scan_recursive_discovery_commands", "discovery_files_per_tick", "discovery_max_runtime_ms"]:
        if term not in main:
            add(errors, f"scan job recursive discovery support missing: {term}")
    for term in ["runtime/scan_complete.json", "runtime/scan_checkpoint.json", "runtime/object_registry.json", "runtime/object_registry_partial.json", "runtime/object_registry_counts.tsv", "runtime/object_registry_counts_partial.tsv", "runtime/baselines/last_scan.json", "runtime/baselines/file_manifest.tsv", "runtime/baselines/last_completed_baseline.json", "runtime/world_state/current/world_state_latest.json"]:
        if term not in main:
            add(errors, f"scan job cannot produce required output: {term}")
    all_saved_block = fn_block("all_saved_files", "direct_known_saved_files")
    if "list_files(" in all_saved_block or "io.popen" in all_saved_block or "cmd /c dir" in all_saved_block:
        add(errors, "all_saved_files exposes recursive discovery outside scan job")
    scan_recursive_block = fn_block("continue_scan_recursive_discovery", "continue_scan_job")
    scan_recursive_open_block = fn_block("open_next_scan_recursive_handle", "continue_scan_recursive_discovery")
    if "io.popen" not in scan_recursive_open_block or "job.recursive_handle" not in scan_recursive_block or "job.recursive_handle" not in scan_recursive_open_block:
        add(errors, "recursive discovery is not scoped to bounded scan job handle consumption")
    log_files_pos = main.find("local function log_files")
    continuity_decl_pos = main.find("local continuity_event")
    if log_files_pos != -1 and (continuity_decl_pos == -1 or continuity_decl_pos > log_files_pos):
        add(errors, "log_files() calls continuity_event without forward declaration before log_files()")
    init_tail_pos = main.find("local function initialize_log_tail")
    prev_decl_pos = main.find("local previous_boot_id")
    if init_tail_pos != -1 and (prev_decl_pos == -1 or prev_decl_pos > init_tail_pos):
        add(errors, "initialize_log_tail() calls previous_boot_id without forward declaration before initialize_log_tail()")
    if "local function continuity_event" in main:
        add(errors, "local function continuity_event remains after forward declaration")
    if "local function previous_boot_id" in main:
        add(errors, "local function previous_boot_id remains after forward declaration")
    for helper in ["continuity_event", "previous_boot_id"]:
        if f"local {helper}" in main and f"local function {helper}" in main:
            add(errors, f"forward-declared startup helper is shadowed by local function: {helper}")
    if 'add("WORLD_ACTOR_SAVE_TOUCH"' not in main:
        add(errors, "UpdateActorToWorldSave is not parsed as WORLD_ACTOR_SAVE_TOUCH")
    if "UPDATE_ACTOR_SAVE_WARNING" in main or "UpdateActorToWorldSave activity" in main:
        add(errors, "reports label UpdateActorToWorldSave as a warning")
    if re.search(r'ev\.type == "WORLD_ACTOR_SAVE_TOUCH".{0,300}add_warning', main, flags=re.DOTALL):
        add(errors, "WORLD_ACTOR_SAVE_TOUCH can be written to warning_events by default")
    if "write_low_importance_raw_events ~= true" not in main:
        add(errors, "low actor touches can be appended to raw_events without aggregation gate")
    if "rotate_if_needed(runtime_path(\"runtime/raw_events.jsonl\")" not in main:
        add(errors, "raw_events.jsonl can grow unbounded")
    if "write_session_summary(s)" not in main:
        add(errors, "session closure does not write session summary")
    if "write_epoch_summary(state.current_epoch)" not in main:
        add(errors, "epoch closure does not write epoch summary")
    if "runtime/days/" not in main or "actor_touches.tsv" not in main:
        add(errors, "daily folder outputs are missing")
    if "summaries_verified_before_prune=true" not in main or "generate_weekly_summary(\"retention_check_before_prune\")" not in main:
        add(errors, "retention can prune detailed evidence before daily/weekly summary exists")
    for term in ["session_id", "epoch_id", "count", "first_seen_ts", "last_seen_ts"]:
        if term not in main.split("handle_actor_touch", 1)[-1]:
            add(errors, f"actor touch rollups lack {term}")
    if "boot_load" in main and "escalated = true" in main:
        add(errors, "boot-load actor touches can escalate by themselves")
    for marker in ["BOOT_MAIN_EXECUTED", "BUILD_RUNNING_VERSION", "THIS_IS_V0.4.0_COMPLETE_BUILD", "BOOT_FROM_MAIN"]:
        if marker in main:
            add(errors, f"main.lua still writes old diagnostic-only marker: {marker}")
    cfg = text(MOD / "config.lua")
    saved_block = cfg.split("saved = {", 1)[1].split("log_tail = {", 1)[0] if "saved = {" in cfg and "log_tail = {" in cfg else ""
    scanning_block = cfg.split("scanning = {", 1)[1].split("admin_ini = {", 1)[0] if "scanning = {" in cfg and "admin_ini = {" in cfg else ""
    if re.search(r"allow_full_find_discovery\s*=\s*true", saved_block):
        add(errors, "saved.allow_full_find_discovery default is true")
    if "allow_full_find_discovery = false" not in saved_block:
        add(errors, "saved.allow_full_find_discovery=false default is missing")
    if "allow_full_find_discovery = true" not in scanning_block or "allow_full_find_discovery_only_in_scan_job = true" not in scanning_block:
        add(errors, "scan-job-only full discovery defaults are missing")
    if 'recursive_discovery_mode = "manifest"' not in scanning_block:
        add(errors, "recursive discovery default is not manifest mode")
    if re.search(r"auto_ban\s*=\s*true", cfg):
        add(errors, "default config has enforcement.auto_ban=true")
    if re.search(r"review_only_mode\s*=\s*false", cfg):
        add(errors, "default config has enforcement.review_only_mode=false")
    if "direct_known_files" not in cfg:
        add(errors, "config.saved.direct_known_files is missing")
    if "server_lifecycle" not in cfg or "post_crash_reconnect_grace_seconds" not in cfg:
        add(errors, "restart grace window config is missing")
    if "poll_interval_ms = 1000" not in cfg:
        add(errors, "poll interval defaults are missing")
    if "detailed_retention_days = 7" not in cfg or "weekly_summary_retention_weeks" not in cfg:
        add(errors, "retention config is missing")
    if "logging = {" not in cfg or "low_importance_mode = \"aggregate\"" not in cfg:
        add(errors, "tiered logging config is missing")
    if "tail_backup_logs = false" not in cfg or "backfill_active_log_on_boot = false" not in cfg:
        add(errors, "tail_backup_logs/backfill active defaults are missing")
    if "max_raw_events_lines = 20000" not in cfg or "daily_summary_retention_days = 90" not in cfg:
        add(errors, "bounded raw/daily retention config is missing")
    if re.search(r"write_admin_ini\s*=\s*true", cfg):
        add(errors, "default config has enforcement.write_admin_ini=true")
    for path in [ROOT / "README.md", ROOT / "INSTALL.md", MOD / "README.txt"]:
        content = text(path)
        stale = re.findall(r"v0\.4\.[012]-alpha", content)
        if stale:
            add(errors, f"stale version string in {path.relative_to(ROOT).as_posix()}: {sorted(set(stale))}")
    if re.search(r'find[^"\n]*2>nul', main):
        add(errors, "POSIX find command uses 2>nul")


def validate_docs(errors: list[str]) -> None:
    docs = [ROOT / "README.md", ROOT / "INSTALL.md", *(ROOT / "docs").glob("*.md")]
    combined = "\n".join(text(p) for p in docs if p.exists())
    for claim in UNAVAILABLE_CLAIMS:
        if re.search(claim, combined, flags=re.IGNORECASE | re.DOTALL):
            add(errors, f"docs claim unavailable live hook as implemented: {claim}")
    if re.search(r"hosting/container logs.*player.?ID", combined, flags=re.IGNORECASE | re.DOTALL):
        add(errors, "docs describe hosting/container logs as player-ID sources")
    for pattern in ADMIN_BAD_EXAMPLES:
        if re.search(pattern, combined, flags=re.IGNORECASE):
            add(errors, f"Admin.ini examples include unsafe BannedPlayer metadata: {pattern}")
    changelog = text(ROOT / "CHANGELOG.md")
    if re.search(r"v0\.4\.(?:0|1|2|3|4|5|6|7|8|9|10)-alpha", changelog):
        add(errors, "CHANGELOG mentions obsolete alpha attempt history")
    readme = text(ROOT / "README.md")
    required_readme_terms = [
        "separately installable guard addon",
        "Fast Install",
        "The First Three Settings To Check",
        "Configuration Guide",
        "Recommended Config Profiles",
        "How The Guard Decides Things",
        "Output Files And What To Check",
        "First Run Checklist",
        "Single World Save Folder",
        "If The World Folder Changes",
        "Ban ID Guide",
        "Evidence Standards",
        "RandomDay Mod changes the server experience",
    ]
    for term in required_readme_terms:
        if term not in readme:
            add(errors, f"README missing required clean-baseline section/text: {term}")


def validate_private_defaults(errors: list[str]) -> None:
    files = [
        ROOT / "README.md",
        ROOT / "INSTALL.md",
        MOD / "config.lua",
        MOD / "README.txt",
        *(MOD / "data").glob("*.json"),
        *(ROOT / "docs").glob("*.md"),
    ]
    for path in files:
        if not path.exists():
            continue
        content = text(path)
        for pattern in PRIVATE_PATTERNS:
            if re.search(pattern, content, flags=re.IGNORECASE):
                add(errors, f"private/default investigation data in {path.relative_to(ROOT).as_posix()}: {pattern}")


def validate_release_zip(errors: list[str]) -> None:
    if not ZIP_PATH.exists():
        add(errors, f"release zip missing: {ZIP_PATH}")
        return
    with zipfile.ZipFile(ZIP_PATH) as zf:
        names = set(zf.namelist())
        for rel in REQUIRED_ZIP:
            if rel not in names:
                add(errors, f"server release ZIP lacks {rel}")
        for name in names:
            inner = name.removeprefix("RandomDayGuard/")
            if inner.startswith("runtime/") and inner not in ALLOWED_RUNTIME_KEEP:
                add(errors, f"server release ZIP includes stale or extra runtime data: {name}")
            if re.search(r"Saved/|Admin\.ini|PlayerData|Logs/.*\.log|test_fixtures|fixtures", name, flags=re.IGNORECASE):
                add(errors, f"server release ZIP includes forbidden private/runtime path: {name}")
            if re.search(r"BOOTSTRAP_REACHED|loader_probe_root|loader_probe|startup_error_root|startup_error|startup_status|poll_status|raw_events|runtime/logs/(?!\.gitkeep$).*[^/]$|log_registry|server_lifecycle|server_epochs|current_server_epoch|weekly|weeks/|ban_queue|request_restart", name, flags=re.IGNORECASE):
                add(errors, f"server release ZIP includes generated runtime artifact: {name}")
            for pattern in FORBIDDEN_ZIP_NAMES:
                if re.search(pattern, name, flags=re.IGNORECASE):
                    add(errors, f"server release ZIP includes forbidden old/diagnostic file: {name}")
            if name.endswith("/"):
                continue
            data = zf.read(name).decode("utf-8", errors="ignore")
            for pattern in PRIVATE_PATTERNS:
                if re.search(pattern, data, flags=re.IGNORECASE):
                    add(errors, f"server release ZIP includes private/default data in {name}: {pattern}")
        manifest = json.loads(zf.read("RandomDayGuard/MANIFEST.json").decode("utf-8"))
        if manifest.get("version") != VERSION:
            add(errors, "release zip version does not match VERSION")
        if VERSION not in zf.read("RandomDayGuard/BUILD_MARKER.txt").decode("utf-8", errors="replace"):
            add(errors, "release zip build marker/version disagree")


def validate_release_files(errors: list[str]) -> None:
    release_dir = ROOT / "releases" / VERSION
    for rel in ["CHECKSUMS.sha256", "RELEASE_NOTES.md"]:
        if not (release_dir / rel).exists():
            add(errors, f"missing release file: releases/{VERSION}/{rel}")


def main() -> int:
    errors: list[str] = []
    validate_required(errors)
    if not errors:
        validate_lua_parse(errors)
        validate_versions(errors)
        validate_runtime(errors)
        validate_docs(errors)
        validate_private_defaults(errors)
        validate_release_zip(errors)
        validate_release_files(errors)
    if errors:
        print("VALIDATION FAILED")
        for err in errors:
            print(f"- {err}")
        return 1
    print(f"VALIDATION PASSED: RandomDayGuard {VERSION}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
