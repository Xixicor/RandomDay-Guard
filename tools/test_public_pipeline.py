#!/usr/bin/env python3
"""Offline contract fixtures for the public reporting and enforcement gates.

These fixtures do not contact or emulate a live game server. They verify the
checked-in Lua boundaries plus fail-closed decision behavior at every
security-sensitive gate. When a Lua compiler is installed, the same executable
test also compiles every owned Lua file. When a Lua interpreter is installed,
it executes the filesystem-only runtime fixture under the repository's .tmp.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass, replace
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
MAIN = ROOT / "RandomDayGuard" / "Scripts" / "main.lua"
PIPELINE = ROOT / "RandomDayGuard" / "Scripts" / "public_pipeline.lua"
CONFIG = ROOT / "RandomDayGuard" / "config.lua"
LUA_RUNTIME_FIXTURE = ROOT / "tests" / "lua" / "public_pipeline_runtime_test.lua"
LUA_LOADER_INTEGRATION_FIXTURE = ROOT / "tests" / "lua" / "loader_integration_test.lua"
LUA_ENFORCEMENT_RUNTIME_FIXTURE = ROOT / "tests" / "lua" / "enforcement_runtime_test.lua"


@dataclass(frozen=True)
class EnforcementFixture:
    enforcement_enabled: bool = True
    ban_on_threshold: bool = True
    auto_ban: bool = True
    review_only: bool = False
    write_admin_ini: bool = True
    admin_enabled: bool = True
    admin_backup_enabled: bool = True
    duplicate_prevention_enabled: bool = True
    admin_path_valid: bool = True
    backup_gate_enabled: bool = True
    readback_gate_enabled: bool = True
    rollback_gate_enabled: bool = True
    clean_id_gate_enabled: bool = True
    moderator_preservation_enabled: bool = True
    existing_ban_preservation_enabled: bool = True
    account_specific_evidence_gate_enabled: bool = True
    clean_numeric_identity: bool = True
    identity_strength: int = 100
    minimum_identity_strength: int = 100
    playerdata_required: bool = False
    playerdata_verified: bool = False
    trusted_or_moderator: bool = False
    admin_available: bool = True
    admin_readable: bool = True
    admin_parse_valid: bool = True
    backup_success: bool = True
    preserve_external_changes: bool = True
    external_change_detected: bool = False
    write_success: bool = True
    readback_success: bool = True
    rollback_success: bool = True


def enforcement_result(case: EnforcementFixture) -> tuple[bool, str]:
    if not case.enforcement_enabled:
        return False, "enforcement_disabled"
    if not case.ban_on_threshold:
        return False, "ban_on_threshold_disabled"
    if not case.auto_ban:
        return False, "auto_ban_disabled"
    if case.review_only:
        return False, "review_only_mode_enabled"
    if not case.write_admin_ini:
        return False, "admin_ini_write_disabled"
    if not case.admin_enabled:
        return False, "admin_ini_disabled"
    if not case.admin_backup_enabled:
        return False, "admin_ini_backup_disabled"
    if not case.duplicate_prevention_enabled:
        return False, "duplicate_prevention_disabled"
    if not case.backup_gate_enabled:
        return False, "backup_safety_gate_disabled"
    if not case.readback_gate_enabled:
        return False, "readback_safety_gate_disabled"
    if not case.rollback_gate_enabled:
        return False, "rollback_safety_gate_disabled"
    if not case.clean_id_gate_enabled:
        return False, "clean_id_safety_gate_disabled"
    if not case.moderator_preservation_enabled:
        return False, "moderator_preservation_disabled"
    if not case.existing_ban_preservation_enabled:
        return False, "existing_ban_preservation_disabled"
    if not case.account_specific_evidence_gate_enabled:
        return False, "account_specific_evidence_gate_disabled"
    if not case.clean_numeric_identity:
        return False, "clean_numeric_identity_required"
    if case.identity_strength < case.minimum_identity_strength:
        return False, "identity_strength_below_minimum"
    if case.playerdata_required and not case.playerdata_verified:
        return False, "playerdata_verification_required"
    if case.trusted_or_moderator:
        return False, "trusted_or_moderator_identity"
    if not case.admin_path_valid:
        return False, "admin_ini_path_invalid"
    if not case.admin_available:
        return False, "admin_ini_unavailable"
    if not case.admin_readable:
        return False, "admin_ini_read_failed"
    if not case.admin_parse_valid:
        return False, "admin_ini_parse_failed"
    if not case.backup_success:
        return False, "admin_ini_backup_failed"
    if case.preserve_external_changes and case.external_change_detected:
        return False, "admin_ini_external_change_detected"
    if not case.write_success:
        return False, "admin_ini_write_failed"
    if not case.readback_success:
        return False, "post_write_verification_failed_rolled_back" if case.rollback_success else "post_write_verification_failed_rollback_failed"
    return True, "enforced"


def route_fixture(
    *,
    active_log: bool = True,
    lineage_complete: bool = True,
    current_cycle_complete: bool = True,
    accounting_status: str = "complete",
    slow_scan_partial: bool = False,
    slow_scan_blocks_current: bool = False,
    accounting_write: bool = True,
    history_write: bool = True,
    route_proof_write: bool = True,
    report_json_write: bool = True,
    report_text_write: bool = True,
    current_players: int = 0,
    historical_players: int = 0,
    movement_events: int = 0,
    same_day_session_events: int = 0,
    current_review_cases: int = 0,
    historical_review_cases: int = 0,
    report_mature: bool = True,
    case_source_status: str = "expected_empty",
    current_critical_failure: bool = False,
    stale_prior_boot_error: bool = False,
    stale_same_boot_prior_poll_error: bool = False,
    source_accounting_enabled: bool = True,
    server_route_enabled: bool = True,
) -> tuple[dict[str, str], bool]:
    contract_writes = source_accounting_enabled and accounting_write and history_write
    current_ready = active_log and lineage_complete and current_cycle_complete and contract_writes and not (
        slow_scan_partial and slow_scan_blocks_current
    )
    history_ready = (
        lineage_complete
        and active_log
        and current_cycle_complete
        and accounting_status not in {"partial", "unavailable"}
        and not slow_scan_partial
        and contract_writes
    )
    critical_ready = current_ready or (lineage_complete and current_critical_failure and contract_writes)
    routes = {
        "server_status": "full" if current_ready else "missing",
        "player_activity": "missing" if not current_ready else ("full" if movement_events or same_day_session_events else "limited_expected_empty"),
        "case_review": "missing" if not current_ready else ("full" if current_review_cases else "limited_expected_empty"),
        "daily_rollup": "missing" if not history_ready else ("full" if report_mature else "limited_expected_empty"),
        "critical_guard": "missing" if not critical_ready else ("full" if current_critical_failure else "limited_expected_empty"),
    }
    if (stale_prior_boot_error or stale_same_boot_prior_poll_error) and not current_critical_failure and current_ready:
        routes["critical_guard"] = "limited_expected_empty"
    if not source_accounting_enabled or not accounting_write or not history_write or not route_proof_write or not report_json_write or not report_text_write:
        routes = {route: "missing" for route in routes}
    if not server_route_enabled:
        routes["server_status"] = "missing"
    notification_allowed = lineage_complete and source_accounting_enabled and accounting_write and history_write and route_proof_write and report_json_write and report_text_write and any(
        status == "full" and (route != "server_status" or server_route_enabled) for route, status in routes.items()
    )
    return routes, notification_allowed


def inventory_root_safe(path: str) -> bool:
    unsafe = "$`%!?^&;|<>\"'"
    return bool(path) and not any(ord(char) < 32 or ord(char) == 127 or char in unsafe for char in path)


def inventory_refs_fixture(names: list[str]) -> list[str]:
    refs: list[str] = []
    for name in names:
        lower = name.lower()
        if lower == ".gitkeep" or lower.startswith(".") or lower.endswith((".tmp", ".lock", "~")):
            continue
        refs.append(name)
    return refs


def notification_candidates_fixture(proofs: dict[str, str], enabled_routes: set[str]) -> list[str]:
    return sorted(route for route, proof in proofs.items() if route in enabled_routes and proof == "full")


def identity_reconciliation_fixture(retained_ids: set[str], current_character_ids: set[str]) -> dict[str, int]:
    retained = retained_ids | current_character_ids
    return {
        "retained_identity_count": len(retained),
        "current_character_identity_count": len(current_character_ids),
        "historical_without_current_character_count": len(retained - current_character_ids),
    }


def durable_ledger_load_fixture(row_count: int, *, maximum: int = 5000) -> tuple[bool, str]:
    if row_count > maximum:
        return False, "identity_ledger_row_limit_exceeded"
    return True, "ready" if row_count else "empty"


def outbox_should_write(existing_dedupe_key: str | None, new_dedupe_key: str) -> bool:
    return not existing_dedupe_key or existing_dedupe_key != new_dedupe_key


TOP_LEVEL_COVERAGE_STATUSES = frozenset({"complete", "complete_with_gaps", "partial", "unavailable"})
SOURCE_STATUS_FIXTURE = frozenset({"available", "expected_empty", "partial", "deferred", "unavailable", "malformed", "permission_denied", "error"})


def report_coverage_fixture(
    accounting_status: str,
    *,
    accounting_write: bool = True,
    history_write: bool = True,
    report_write: bool = True,
    route_proof_write: bool = True,
) -> dict[str, str]:
    coverage_status = accounting_status if accounting_status in TOP_LEVEL_COVERAGE_STATUSES else "unavailable"
    if not accounting_write or not history_write:
        coverage_status = "unavailable"
    # Paired report and route-proof failures alter route_result, not source coverage.
    _ = report_write, route_proof_write
    return {route: coverage_status for route in ("server_status", "daily_rollup", "player_activity", "case_review", "critical_guard")}


VALUE_DICTIONARY_FIXTURE = {
    "route_proof": {
        "full": ("Current route evidence is complete for its owned scope.", "strong"),
        "limited_expected_empty": ("The route is explicitly empty for its owned scope.", "strong"),
        "missing": ("The route is missing required proof.", "limited"),
    },
    "coverage": {
        "complete": ("Configured source accounting is terminal with no named source gap.", "strong"),
        "complete_with_gaps": ("Configured source accounting is terminal with explicit optional gaps.", "moderate"),
        "partial": ("Bounded source accounting is still incomplete.", "limited"),
        "unavailable": ("Required source accounting is unavailable.", "limited"),
    },
    "identity_confidence": {
        "direct_login_request": ("Identity is mapped from a server login request.", "strong"),
        "playerdata_only": ("Identity comes from a current PlayerData filename only.", "limited"),
        "unknown": ("Identity confidence is unknown; review source evidence.", "unknown"),
    },
}


def translated_value_fixture(category: str, value: str) -> dict[str, object]:
    mapped = VALUE_DICTIONARY_FIXTURE.get(category, {}).get(value)
    if mapped:
        meaning, confidence = mapped
        return {"category": category, "raw_value": value, "meaning": meaning, "confidence": confidence, "mapped": True}
    return {
        "category": category,
        "raw_value": value,
        "meaning": f"Unknown or unmapped {category} value ({value}); review source evidence before drawing conclusions.",
        "confidence": "unknown",
        "mapped": False,
    }


def payload_matches_cycle(
    payload: dict[str, object],
    *,
    version: str,
    boot_id: str,
    epoch_id: str,
    poll_id: int,
    source_generated_ts: str,
) -> bool:
    freshness = payload.get("source_freshness") or {}
    result = payload.get("route_result") or {}
    return (
        payload.get("version") == version
        and payload.get("boot_id") == boot_id
        and payload.get("epoch_id") == epoch_id
        and payload.get("poll_id") == poll_id
        and isinstance(freshness, dict)
        and freshness.get("current_cycle") is True
        and isinstance(result, dict)
        and result.get("status") in {"full", "limited_expected_empty"}
        and str(payload.get("generated_ts") or "") >= source_generated_ts
    )


def retained_case_fixture(text: str, source_ref: str) -> dict[str, object] | None:
    try:
        payload = json.loads(text)
    except json.JSONDecodeError:
        return None
    if not isinstance(payload, dict) or not isinstance(payload.get("case_id"), str) or not payload["case_id"]:
        return None
    accounts = sorted({str(value) for value in payload.get("accounts", []) if str(value)})
    references = {source_ref}
    for key in ["source_references", "evidence_references", "report_paths"]:
        references.update(str(value) for value in payload.get(key, []) if str(value))
    evidence_items: set[str] = set()
    for key in ["evidence", "evidence_event_ids", "confirmed_fact_event_ids"]:
        value = payload.get(key, [])
        if isinstance(value, list):
            evidence_items.update(str(item) for item in value if str(item))
    return {
        "case_id": payload["case_id"],
        "accounts": accounts,
        "score": max(float(payload.get("score") or payload.get("central_account_score") or 0), 0),
        "scope": "historical",
        "source_references": sorted(references),
        "evidence_items": sorted(evidence_items),
    }


def bounded_text_values(values: list[str], *, max_items: int = 8, max_bytes: int = 512) -> list[str]:
    bounded = [value.replace("\r", " ").replace("\n", " ").replace("\t", " ")[:max_bytes] for value in values[:max_items]]
    if len(values) > len(bounded):
        bounded.append(f"{len(values) - len(bounded)} additional bounded items omitted; review structured output.")
    return bounded


def source_probe_fixture(*, present: bool, error: str = "", admin_text_valid: bool = True) -> str:
    if present:
        return "available" if admin_text_valid else "malformed"
    lowered = error.lower()
    if any(term in lowered for term in ["permission denied", "access is denied", "operation not permitted"]):
        return "permission_denied"
    if any(term in lowered for term in ["no such file", "cannot find", "not found"]):
        return "missing"
    return "unavailable"


def parse_bans_fixture(text: str) -> tuple[set[str], bool]:
    section = ""
    section_count = 0
    bans: set[str] = set()
    valid = True
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if line.startswith("[") and line.endswith("]"):
            section = line[1:-1]
            if section == "BannedPlayers":
                section_count += 1
                valid = valid and section_count == 1
            continue
        if not line or line.startswith((";", "#", "--")):
            continue
        if line.startswith("BannedPlayer"):
            if section != "BannedPlayers" or "=" not in line:
                valid = False
                continue
            value = line.split("=", 1)[1].strip()
            if not value.isdigit():
                valid = False
            else:
                bans.add(value)
    return bans, valid


def find_lua_tool(names: list[str], local_binary: str) -> str | None:
    for name in names:
        executable = shutil.which(name)
        if executable:
            return executable
    local_app_data = os.environ.get("LOCALAPPDATA")
    if local_app_data:
        candidate = Path(local_app_data) / "Programs" / "Lua" / "bin" / local_binary
        try:
            if candidate.is_file():
                return str(candidate)
        except OSError:
            # An optional per-user Lua installation may be hidden by Windows
            # policy. Treat it as unavailable so the offline fixture can use
            # another interpreter or report the tool unavailable truthfully.
            pass
    return None


def find_lua_interpreter(explicit: Path | None = None) -> str | None:
    if explicit is not None:
        candidate = explicit if explicit.is_absolute() else ROOT / explicit
        if not candidate.is_file():
            raise FileNotFoundError(f"configured Lua interpreter does not exist: {explicit}")
        return str(candidate.resolve())
    return find_lua_tool(["lua", "lua5.4", "lua54", "lua5.3", "lua53", "luajit"], "lua.exe")


def lua_process_args(interpreter: str, *args: str) -> list[str]:
    if Path(interpreter).suffix.lower() == ".py":
        return [sys.executable, interpreter, *args]
    return [interpreter, *args]


def assert_lua_syntax_if_available(interpreter: str | None) -> str:
    lua_files = [
        MAIN,
        PIPELINE,
        CONFIG,
        LUA_RUNTIME_FIXTURE,
        LUA_LOADER_INTEGRATION_FIXTURE,
        LUA_ENFORCEMENT_RUNTIME_FIXTURE,
    ]
    compiler = find_lua_tool(["luac", "luac5.4", "luac54", "luac5.3", "luac53"], "luac.exe")
    if compiler:
        for path in lua_files:
            subprocess.run([compiler, "-p", str(path)], cwd=ROOT, check=True)
        return compiler
    if interpreter:
        for path in lua_files:
            source = json.dumps(path.as_posix())
            subprocess.run(lua_process_args(interpreter, "-e", f"assert(loadfile({source}))"), cwd=ROOT, check=True)
        return interpreter
    return "unavailable"


def assert_lua_runtime_fixture_if_available(interpreter: str | None) -> str:
    if not interpreter:
        return "unavailable"
    temp_root = ROOT / ".tmp"
    temp_root.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="public-pipeline-runtime-", dir=temp_root) as fixture_root:
        result = subprocess.run(
            lua_process_args(interpreter, str(LUA_RUNTIME_FIXTURE), fixture_root),
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
    output = (result.stdout + result.stderr).strip()
    if result.returncode != 0:
        raise AssertionError(f"real Lua public-pipeline runtime fixture failed: {output}")
    if "REAL LUA PUBLIC PIPELINE RUNTIME FIXTURE PASSED" not in result.stdout:
        raise AssertionError(f"real Lua public-pipeline runtime fixture omitted its pass marker: {output}")
    return interpreter


def assert_lua_loader_integration_fixture_if_available(interpreter: str | None) -> str:
    if not interpreter:
        return "unavailable"
    temp_root = ROOT / ".tmp"
    temp_root.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="loader-integration-", dir=temp_root) as fixture_root:
        result = subprocess.run(
            lua_process_args(interpreter, str(LUA_LOADER_INTEGRATION_FIXTURE), str(ROOT), fixture_root),
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
    output = (result.stdout + result.stderr).strip()
    if result.returncode != 0:
        raise AssertionError(f"real Lua loader integration fixture failed: {output}")
    if "REAL LUA LOADER INTEGRATION FIXTURE PASSED" not in result.stdout:
        raise AssertionError(f"real Lua loader integration fixture omitted its pass marker: {output}")
    return interpreter


def assert_lua_enforcement_runtime_fixture_if_available(interpreter: str | None) -> str:
    if not interpreter:
        return "unavailable"
    temp_root = ROOT / ".tmp"
    temp_root.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="enforcement-runtime-", dir=temp_root) as fixture_root:
        result = subprocess.run(
            lua_process_args(interpreter, str(LUA_ENFORCEMENT_RUNTIME_FIXTURE), str(ROOT), fixture_root),
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
    output = (result.stdout + result.stderr).strip()
    if result.returncode != 0:
        raise AssertionError(f"real Lua Admin.ini enforcement fixture failed: {output}")
    if "REAL LUA ADMIN.INI ENFORCEMENT FIXTURE PASSED" not in result.stdout:
        raise AssertionError(f"real Lua Admin.ini enforcement fixture omitted its pass marker: {output}")
    return interpreter


def assert_static_contract() -> None:
    main = MAIN.read_text(encoding="utf-8")
    pipeline = PIPELINE.read_text(encoding="utf-8")
    config = CONFIG.read_text(encoding="utf-8")

    files = {path.relative_to(ROOT).as_posix() for path in ROOT.rglob("*") if path.is_file()}
    if "RandomDayGuard/Scripts/main.lua" not in files or "RandomDayGuard/scripts/main.lua" in files:
        raise AssertionError("canonical loader layout is invalid")

    for term in [
        'local IS_WINDOWS = package and package.config',
        'local command = IS_WINDOWS',
        'local CREATED_DIRECTORIES = {}',
        'if CREATED_DIRECTORIES[cache_key] then return true end',
        'cmd /c if not exist ',
        'recursive_listing_commands(root, source_prefix)',
        'recursive_listing_commands(root, "listing")',
        'recursive_listing_commands(root, "scan_job")',
    ]:
        if term not in main:
            raise AssertionError(f"platform-specific shell command contract missing: {term}")
    mkdir_block = main.split("local function mkdir_p", 1)[1].split("local function read_file", 1)[0]
    if mkdir_block.count("os.execute(") != 1:
        raise AssertionError("mkdir_p must execute exactly one platform-selected command")

    for term in [
        'Scripts/public_pipeline.lua',
        'enforcement_disabled',
        'ban_on_threshold_disabled',
        'admin_ini_disabled',
        'admin_ini_backup_disabled',
        'duplicate_prevention_disabled',
        'admin_ini_path_invalid',
        'admin_ini_path_outside_saved_root',
        'admin_ini_external_change_detected',
        'write_admin_ini_controlled',
        'publish_admin_state',
        'current_startup_error',
        'current_poll_error',
        'current_poll_source',
        'current_startup_error=false',
        'current_poll_error=false',
        'source="active_log_read"',
        'minimum_identity_strength',
        'identity_strength_below_minimum',
        'admin_ini_backup_failed',
        'admin_ini_write_failed',
        'post_write_verification_failed',
        'rollback_attempted',
        'rollback_success',
        'review_only_mode_enabled',
        'backup_safety_gate_disabled',
        'readback_safety_gate_disabled',
        'rollback_safety_gate_disabled',
        'clean_id_safety_gate_disabled',
        'moderator_preservation_disabled',
        'existing_ban_preservation_disabled',
        'account_specific_evidence_gate_disabled',
        'admin_ini_banned_player_outside_section',
    ]:
        if term not in main:
            raise AssertionError(f"runtime enforcement/reporting hook missing: {term}")

    for term in [
        'local IS_WINDOWS = package and package.config',
        'if IS_WINDOWS then',
        'available=true',
        'expected_empty=true',
        'partial=true',
        'deferred=true',
        'unavailable=true',
        'malformed=true',
        'permission_denied=true',
        'error=true',
        'full=true',
        'limited_expected_empty=true',
        'missing=true',
        'read_durable_accounts',
        'DURABLE_LEDGER_MAX_ROWS = 5000',
        'identity_ledger_row_limit_exceeded',
        'read_durable_session_count',
        'discover_current_playerdata_files_bounded',
        'current_playerdata_id',
        'expected-empty is not proven',
        'bounded_runtime_inventory',
        'pcall(io.popen, command)',
        'inventory_command_open_failed',
        'inventory_command_read_failed',
        'inventory_command_close_failed',
        'unsafe_inventory_root',
        'inventory_root_is_safe',
        'UNSAFE_SHELL_PATH_CHARS',
        'bookkeeping',
        'file_readable(path)',
        'runtime/raid_cases',
        'runtime/forensic_days',
        'runtime/warnings',
        'runtime/evidence',
        'current_evidence_is_not_history=true',
        'runtime/history/public_accounts.tsv',
        'write_durable_accounts',
        'read_retained_cases',
        'retained_case_from_json',
        'retained_case_parse_failure_count',
        'evidence_items',
        'scope="current"',
        'scope="historical"',
        'historical_context=false',
        'version=cycle.version',
        'boot_id=cycle.boot_id',
        'epoch_id=cycle.epoch_id',
        'poll_id=cycle.poll_id',
        'source_freshness=cycle.source_freshness',
        'source_poll_id=source.poll_id',
        'cycle_id=cycle.cycle_id',
        'route_result=report.route_result',
        'current_cycle_lineage_complete',
        'current_cycle_proof_complete',
        'fresh_current_poll',
        'slow_world_scan_blocks_current_reports',
        'current_boot_error_only',
        'route_proof_write_ok',
        'outbox_outcome=suppression_outcome',
        'source_accounting_disabled',
        'route_output_ready',
        'report_route_disabled_or_incomplete',
        'local_outbox_write_failed',
        'suppressed_current_cycle',
        'current_cycle_suppressed',
        'file_readable(output_path)',
        'contract_writes_ok',
        'delivery_backend="none"',
        'delivery_attempted=false',
        'permission_denied',
        'admin_status = "malformed"',
        'retaining a success claim after its paired output failed',
        'TRANSLATED_MAX_ITEMS',
        'TRANSLATED_MAX_REFS',
        'TRANSLATED_MAX_VALUE_BYTES',
        'append_translated_section',
        'additional bounded items omitted',
        'VALUE_DICTIONARY',
        'TRANSLATION_DICTIONARY_VERSION',
        'OPERATOR_BRIEF_CONTRACT',
        'translated_value',
        'Unknown or unmapped',
        'rating_explanations',
        'translation_notes',
        'review_first=true',
        'current_and_retained_counts_computed_before_candidate_promotion=true',
        'playerdata_presence_is_activity=false',
        'player_activity_present',
        'today_session_event_count',
        'historical_identity_eligible=false',
        'expected_empty_reason = player_proof == "limited_expected_empty" and "no_player_activity"',
        'expected_empty_reason = case_proof == "limited_expected_empty" and "no_case_review_activity"',
        'expected_empty_reason = daily_proof == "limited_expected_empty" and "daily_rollup_not_mature"',
        'once_per_day_continuity = true',
        'local_outbox_deduplicated',
        'current_cycle_suppressed_deduplicated',
        'dedupe_key=dedupe_key',
        'historical_identity_is_current_activity = false',
        'playerdata_identity_is_current_activity = false',
        'current_session_count',
        'historical_session_count = prior_session_count',
        'tonumber(poll_error.poll_id) == tonumber(cycle.poll_id)',
    ]:
        if term not in pipeline:
            raise AssertionError(f"public pipeline contract missing: {term}")

    coverage_dictionary = pipeline.split("coverage = {", 1)[1].split("source_freshness = {", 1)[0]
    if "error=" in coverage_dictionary:
        raise AssertionError("top-level coverage dictionary must not map source-level error")
    if 'report.coverage_status = "error"' in pipeline:
        raise AssertionError("report coverage_status escaped the four-value top-level enum")
    if 'report.coverage_status = "unavailable"' not in pipeline:
        raise AssertionError("required accounting/history write failure must map report coverage to unavailable")

    active_block = pipeline.split('source_record("active_log"', 1)[1].split('source_record("admin_ini"', 1)[0]
    if '"expected_empty"' in active_block:
        raise AssertionError("missing active log must not be classified expected-empty")
    if pipeline.find("local runtime_ref") > pipeline.find("local function bounded_runtime_inventory"):
        raise AssertionError("runtime_ref must be in lexical scope before bounded inventory is defined")
    if "runtime_ref = function(path)" not in pipeline:
        raise AssertionError("forward-declared runtime_ref assignment is missing")
    if pipeline.find("local prior_case_refs") > pipeline.find("local function collect_sources"):
        raise AssertionError("retained case/report/evidence inventory must be captured before current-boot collection")
    if pipeline.find('runtime/history/public_accounts.tsv') > pipeline.find("local function collect_sources"):
        raise AssertionError("durable account history must load before current-boot collection")
    if 'source_record("playerdata_filenames", "historical"' in pipeline:
        raise AssertionError("current Saved-root PlayerData rows must not be labeled historical")
    if 'or ((current_count == 0 and historical_count == 0)' in pipeline:
        raise AssertionError("identity inventory must not own player-activity route proof")
    if 'or (#cases > 0 and "full"' in pipeline:
        raise AssertionError("retained historical cases must not own current case-review route proof")
    if "local merged_accounts" in pipeline:
        raise AssertionError("current and historical player rows must not be merged into one scope")
    for stale_error_probe in [
        'file_readable(runtime_path("runtime/startup_error.txt"))',
        'file_readable(runtime_path("runtime/poll_error.txt"))',
    ]:
        if stale_error_probe in pipeline:
            raise AssertionError("prior-boot text error artifact still owns current critical proof")

    poll_once = main.split("local function poll_once", 1)[1].split("local function safe_poll_once", 1)[0]
    safe_poll = main.split("local function safe_poll_once", 1)[1].split("local function schedule_next_poll", 1)[0]
    if 'refresh_public_pipeline("scheduled"' in poll_once:
        raise AssertionError("public route proof must not refresh before poll finalization")
    direct_refresh = 'refresh_public_pipeline(state.current_poll_error and "poll_error"' in safe_poll
    deferred_refresh = (
        "local function run_public_report_opportunity" in main
        and "state.report_refresh_pending = true" in safe_poll
        and "return refresh_public_pipeline(refresh_reason, false)" in main
    )
    if not (direct_refresh or deferred_refresh):
        raise AssertionError("poll finalization must schedule exactly one current success/error route-proof opportunity")

    append_ban = main.split("local function append_ban", 1)[1].split("local function evaluate_enforcement", 1)[0]
    clean_ban_id = main.split("local function clean_ban_id", 1)[1].split("local function normalize_account_id", 1)[0]
    if 'match("^(%d+)$")' not in clean_ban_id or 'match("^(%d+)_%+_|%S+$")' not in clean_ban_id:
        raise AssertionError("ban identity parser must accept only pure numeric IDs or the fully anchored documented ConnectID form")
    if 'match("^(%d+)")' in clean_ban_id:
        raise AssertionError("ban identity parser must not accept arbitrary numeric prefixes")
    if append_ban.find("read_file(admin_path)") > append_ban.find("publish_admin_state(admin_path, text, nil)"):
        raise AssertionError("moderator state must refresh from the exact pre-write Admin.ini snapshot")
    if append_ban.find("admin_ini_external_change_detected") > append_ban.find("write_admin_ini_controlled(admin_path, text"):
        raise AssertionError("external-change detection must run before Admin.ini mutation")
    for term in [
        "verify_text ~= text",
        "current_text == text",
        "rollback_refused_external_change",
        "simple_hash(text)",
    ]:
        if term not in append_ban:
            raise AssertionError(f"Admin.ini byte-safe transaction contract missing: {term}")

    for forbidden in ["discord", "webhook", "/AMP/", "Z:/AMP", "Hostinger"]:
        if forbidden.lower() in (pipeline + config).lower():
            raise AssertionError(f"provider-specific runtime default found: {forbidden}")

    for default in [
        "auto_ban = false",
        "review_only_mode = true",
        "write_admin_ini = false",
        "minimum_identity_strength = 100",
        "require_account_specific_evidence = true",
        'mode = "local_file_outbox"',
    ]:
        if default not in config:
            raise AssertionError(f"safe public default missing: {default}")


def assert_enforcement_fixtures() -> None:
    base = EnforcementFixture()
    if enforcement_result(base) != (True, "enforced"):
        raise AssertionError("strong-identity positive fixture must pass every gate")

    negative_cases = {
        "enforcement_disabled": replace(base, enforcement_enabled=False),
        "ban_on_threshold_disabled": replace(base, ban_on_threshold=False),
        "auto_ban_disabled": replace(base, auto_ban=False),
        "review_only_mode_enabled": replace(base, review_only=True),
        "admin_ini_write_disabled": replace(base, write_admin_ini=False),
        "admin_ini_disabled": replace(base, admin_enabled=False),
        "admin_ini_backup_disabled": replace(base, admin_backup_enabled=False),
        "duplicate_prevention_disabled": replace(base, duplicate_prevention_enabled=False),
        "backup_safety_gate_disabled": replace(base, backup_gate_enabled=False),
        "readback_safety_gate_disabled": replace(base, readback_gate_enabled=False),
        "rollback_safety_gate_disabled": replace(base, rollback_gate_enabled=False),
        "clean_id_safety_gate_disabled": replace(base, clean_id_gate_enabled=False),
        "moderator_preservation_disabled": replace(base, moderator_preservation_enabled=False),
        "existing_ban_preservation_disabled": replace(base, existing_ban_preservation_enabled=False),
        "account_specific_evidence_gate_disabled": replace(base, account_specific_evidence_gate_enabled=False),
        "clean_numeric_identity_required": replace(base, clean_numeric_identity=False),
        "identity_strength_below_minimum": replace(base, identity_strength=70),
        "playerdata_verification_required": replace(base, playerdata_required=True, playerdata_verified=False),
        "trusted_or_moderator_identity": replace(base, trusted_or_moderator=True),
        "admin_ini_path_invalid": replace(base, admin_path_valid=False),
        "admin_ini_unavailable": replace(base, admin_available=False),
        "admin_ini_read_failed": replace(base, admin_readable=False),
        "admin_ini_parse_failed": replace(base, admin_parse_valid=False),
        "admin_ini_backup_failed": replace(base, backup_success=False),
        "admin_ini_external_change_detected": replace(base, external_change_detected=True),
        "admin_ini_write_failed": replace(base, write_success=False),
    }
    for expected, fixture in negative_cases.items():
        result = enforcement_result(fixture)
        if result != (False, expected):
            raise AssertionError(f"gate did not fail closed for {expected}: {result}")

    readback_ok = enforcement_result(replace(base, readback_success=False, rollback_success=True))
    if readback_ok != (False, "post_write_verification_failed_rolled_back"):
        raise AssertionError("readback failure must fail closed after successful rollback")
    rollback_failed = enforcement_result(replace(base, readback_success=False, rollback_success=False))
    if rollback_failed != (False, "post_write_verification_failed_rollback_failed"):
        raise AssertionError("rollback failure must remain failed closed")


def assert_route_fixtures() -> None:
    routes, notify = route_fixture()
    if routes["player_activity"] != "limited_expected_empty" or routes["case_review"] != "limited_expected_empty":
        raise AssertionError("eligible empty routes must be limited_expected_empty")
    if not notify:
        raise AssertionError("completed full server output may be notification eligible")

    partial, partial_notify = route_fixture(
        accounting_status="partial",
        slow_scan_partial=True,
        historical_players=2,
        historical_review_cases=1,
    )
    if partial["server_status"] != "full":
        raise AssertionError("nonblocking slow history must not suppress current server status")
    if partial["player_activity"] != "limited_expected_empty":
        raise AssertionError("retained player artifacts must not own current player activity")
    if partial["case_review"] != "limited_expected_empty":
        raise AssertionError("historical case artifacts must not own current case review")
    if partial["daily_rollup"] != "missing":
        raise AssertionError("partial historical scan must remain explicit on the daily route")
    if partial_notify is not True:
        raise AssertionError("independent full server status remains eligible when only slow history is partial")

    blocking, _ = route_fixture(
        accounting_status="partial",
        slow_scan_partial=True,
        slow_scan_blocks_current=True,
        current_players=1,
    )
    for route in ["server_status", "player_activity", "case_review", "critical_guard"]:
        if blocking[route] != "missing":
            raise AssertionError(f"explicit blocking slow scan must suppress current route {route}")

    missing_log, _ = route_fixture(active_log=False, historical_players=2)
    if missing_log["server_status"] != "missing" or missing_log["player_activity"] != "missing":
        raise AssertionError("missing active log must fail current routes closed")

    missing_cycle, _ = route_fixture(current_cycle_complete=False, movement_events=1, current_review_cases=1)
    if set(missing_cycle.values()) != {"missing"}:
        raise AssertionError("missing version/boot/epoch/poll/freshness proof must fail every route closed")
    missing_lineage, _ = route_fixture(lineage_complete=False, movement_events=1, current_review_cases=1)
    if set(missing_lineage.values()) != {"missing"}:
        raise AssertionError("route result must bind complete version/boot/epoch/poll lineage")
    stale_error, _ = route_fixture(stale_prior_boot_error=True)
    if stale_error["critical_guard"] != "limited_expected_empty":
        raise AssertionError("stale prior-boot errors must not create a current critical failure")
    stale_poll_error, _ = route_fixture(stale_same_boot_prior_poll_error=True)
    if stale_poll_error["critical_guard"] != "limited_expected_empty":
        raise AssertionError("same-boot prior-poll errors must not create current critical proof")
    current_error, _ = route_fixture(current_critical_failure=True)
    if current_error["critical_guard"] != "full":
        raise AssertionError("current-boot critical evidence must own the critical route")
    failed_source_current_error, _ = route_fixture(active_log=False, current_cycle_complete=False, current_critical_failure=True)
    if failed_source_current_error["critical_guard"] != "full":
        raise AssertionError("an exact current-poll source failure must complete the failure-only critical route")
    historical_only, _ = route_fixture(historical_players=5)
    if historical_only["player_activity"] != "limited_expected_empty":
        raise AssertionError("retained identity alone must never complete the player route")
    current_identity_only, _ = route_fixture(current_players=2)
    if current_identity_only["player_activity"] != "limited_expected_empty":
        raise AssertionError("current identity alone must not complete the player route")
    movement, _ = route_fixture(movement_events=1)
    if movement["player_activity"] != "full":
        raise AssertionError("current movement must complete the player route")
    same_day_session, _ = route_fixture(same_day_session_events=1)
    if same_day_session["player_activity"] != "full":
        raise AssertionError("same-day session evidence must complete the player route")
    historical_case, _ = route_fixture(historical_review_cases=3)
    if historical_case["case_review"] != "limited_expected_empty":
        raise AssertionError("retained historical cases must not complete current case review")
    current_case, _ = route_fixture(current_review_cases=1)
    if current_case["case_review"] != "full":
        raise AssertionError("a current named review subject must complete case review")
    unknown_case_empty, _ = route_fixture(case_source_status="unavailable")
    if unknown_case_empty["case_review"] != "limited_expected_empty" or unknown_case_empty["server_status"] != "full":
        raise AssertionError("current case expected-empty must remain explicit even when retained inventory is unavailable")
    immature_daily, _ = route_fixture(report_mature=False)
    if immature_daily["daily_rollup"] != "limited_expected_empty":
        raise AssertionError("daily continuity must remain explicitly not mature until its report gate passes")
    if routes["daily_rollup"] != "full":
        raise AssertionError("a mature daily continuity report must be full even on a quiet day")

    for injection in [
        {"accounting_write": False},
        {"history_write": False},
        {"route_proof_write": False},
        {"report_json_write": False},
        {"report_text_write": False},
    ]:
        failed, notify = route_fixture(historical_players=2, current_review_cases=1, **injection)
        if set(failed.values()) != {"missing"} or notify:
            raise AssertionError(f"write failure did not fail every route/notification closed: {injection}")
    disabled_accounting, disabled_notify = route_fixture(source_accounting_enabled=False, historical_players=2, current_review_cases=1)
    if set(disabled_accounting.values()) != {"missing"} or disabled_notify:
        raise AssertionError("disabled source accounting must fail all reports and notification closed")
    disabled_server, disabled_server_notify = route_fixture(server_route_enabled=False)
    if disabled_server["server_status"] != "missing":
        raise AssertionError("disabled server report route must remain missing")
    if "server_status" in notification_candidates_fixture(disabled_server, {"server_status"}):
        raise AssertionError("disabled report route must not queue notification from an unwritten report")
    if notification_candidates_fixture({"server_status": "full"}, set()):
        raise AssertionError("a full in-memory report must not notify when its report route is disabled")


def assert_coverage_contract_fixtures() -> None:
    if "error" not in SOURCE_STATUS_FIXTURE:
        raise AssertionError("source-level probe error status must remain explicit")
    if set(VALUE_DICTIONARY_FIXTURE["coverage"]) != TOP_LEVEL_COVERAGE_STATUSES:
        raise AssertionError("coverage dictionary differs from the exact top-level contract")
    if translated_value_fixture("coverage", "error")["mapped"] is not False:
        raise AssertionError("source-level error must remain explicitly unmapped as report coverage")

    for accounting_status in TOP_LEVEL_COVERAGE_STATUSES:
        reports = report_coverage_fixture(accounting_status)
        if set(reports.values()) != {accounting_status}:
            raise AssertionError(f"valid accounting coverage changed unexpectedly: {accounting_status}")
    for failure in ({"accounting_write": False}, {"history_write": False}):
        reports = report_coverage_fixture("complete_with_gaps", **failure)
        if set(reports.values()) != {"unavailable"}:
            raise AssertionError(f"required contract write did not map coverage to unavailable: {failure}")
    for failure in ({"report_write": False}, {"route_proof_write": False}):
        reports = report_coverage_fixture("complete_with_gaps", **failure)
        if set(reports.values()) != {"complete_with_gaps"}:
            raise AssertionError(f"output-layer failure incorrectly changed source coverage: {failure}")
    emitted = set(report_coverage_fixture("error").values())
    if not emitted <= TOP_LEVEL_COVERAGE_STATUSES or emitted != {"unavailable"}:
        raise AssertionError("unknown/source-level accounting status escaped the top-level coverage enum")


def assert_inventory_fixtures() -> None:
    for unsafe in [
        "/srv/guard$(id)/runtime",
        "/srv/guard`id`/runtime",
        "C:/Guard%TEMP%/runtime",
        "C:/Guard!TEMP!/runtime",
        "C:/Guard & whoami/runtime",
    ]:
        if inventory_root_safe(unsafe):
            raise AssertionError(f"unsafe inventory root was accepted: {unsafe}")
    if not inventory_root_safe("C:/Game Servers/RandomDayGuard/runtime/evidence"):
        raise AssertionError("portable safe inventory root was rejected")
    for safe in [
        "C:/Program Files (x86)/Abiotic Factor/Saved",
        "D:/Servidores/Juego Español/Guard runtime",
        "/srv/abiotic factor/Servidor (principal)/Saved",
    ]:
        if not inventory_root_safe(safe):
            raise AssertionError(f"valid generic server root was rejected: {safe}")

    if inventory_refs_fixture([".gitkeep", ".state", "write.tmp", "scan.lock", "editor~"]):
        raise AssertionError("empty package skeleton/bookkeeping must remain expected-empty")
    if inventory_refs_fixture([".gitkeep", "case.json"]) != ["case.json"]:
        raise AssertionError("real retained artifact was not distinguished from package skeleton")


def assert_identity_translation_fixtures() -> None:
    counts = identity_reconciliation_fixture({"100", "200", "300"}, {"100", "200"})
    if counts != {
        "retained_identity_count": 3,
        "current_character_identity_count": 2,
        "historical_without_current_character_count": 1,
    }:
        raise AssertionError(f"current-vs-retained identity reconciliation differs: {counts}")
    if durable_ledger_load_fixture(5000) != (True, "ready"):
        raise AssertionError("the documented 5000-row ledger load boundary must be accepted")
    if durable_ledger_load_fixture(5001) != (False, "identity_ledger_row_limit_exceeded"):
        raise AssertionError("ledger rows beyond 5000 must fail closed instead of truncating")

    daily_key = "daily_rollup:2026-07-16:public_operator_brief_v1:eligible"
    if outbox_should_write(daily_key, daily_key):
        raise AssertionError("same-day daily-rollup outbox payload must be deduplicated")
    if not outbox_should_write(daily_key, "daily_rollup:2026-07-17:public_operator_brief_v1:eligible"):
        raise AssertionError("a new UTC date must permit a new daily continuity payload")

    mapped = translated_value_fixture("route_proof", "full")
    if mapped["mapped"] is not True or mapped["confidence"] != "strong":
        raise AssertionError("known dictionary values must produce a mapped translation note")
    unknown = translated_value_fixture("route_proof", "future_status")
    if unknown["mapped"] is not False or "Unknown or unmapped" not in str(unknown["meaning"]):
        raise AssertionError("unknown dictionary values must remain explicit and review-first")


def assert_case_and_output_fixtures() -> None:
    retained = retained_case_fixture(
        json.dumps(
            {
                "case_id": "CASE-001",
                "accounts": ["200", "100", "100"],
                "score": 91,
                "source_references": ["runtime/evidence/event.json"],
                "evidence_event_ids": ["EVENT-2", "EVENT-1"],
            }
        ),
        "runtime/raid_cases/CASE-001.json",
    )
    if not retained or retained["case_id"] != "CASE-001" or retained["accounts"] != ["100", "200"]:
        raise AssertionError("retained case summary fields were not parsed into a named review subject")
    if "runtime/evidence/event.json" not in retained["source_references"] or retained["scope"] != "historical":
        raise AssertionError("retained case summary lost evidence references or historical scope")
    if retained_case_fixture('{"accounts":["100"]}', "runtime/raid_cases/malformed.json") is not None:
        raise AssertionError("retained case without case_id must not count as review material")
    if retained_case_fixture("not-json", "runtime/raid_cases/malformed.json") is not None:
        raise AssertionError("malformed retained case must remain an explicit parse failure")

    bounded = bounded_text_values([("fact-%02d-" % index) + ("x" * 700) for index in range(12)])
    if len(bounded) != 9 or not bounded[-1].startswith("4 additional bounded items omitted"):
        raise AssertionError("translated evidence lists must be item-bounded with an explicit omission count")
    if any("\n" in value or "\t" in value or len(value) > 512 for value in bounded[:-1]):
        raise AssertionError("translated evidence values must be single-line and size-bounded")

    current_payload = {
        "version": "v-public",
        "generated_ts": "2026-07-16T12:00:05Z",
        "boot_id": "boot-current",
        "epoch_id": "epoch-current",
        "poll_id": 9,
        "source_freshness": {"current_cycle": True, "status": "current_poll_error"},
        "route_result": {"status": "full", "completed": True, "expected_empty": False},
    }
    cycle = {
        "version": "v-public",
        "boot_id": "boot-current",
        "epoch_id": "epoch-current",
        "poll_id": 9,
        "source_generated_ts": "2026-07-16T12:00:04Z",
    }
    if not payload_matches_cycle(current_payload, **cycle):
        raise AssertionError("exact current-cycle critical payload should satisfy proof")
    if payload_matches_cycle({**current_payload, "poll_id": 8}, **cycle):
        raise AssertionError("same-boot old-poll payload must not satisfy current critical proof")
    if payload_matches_cycle({**current_payload, "boot_id": "boot-old"}, **cycle):
        raise AssertionError("prior-boot payload must not satisfy current critical proof")
    if payload_matches_cycle({**current_payload, "generated_ts": "2026-07-16T12:00:03Z"}, **cycle):
        raise AssertionError("payload older than its source must not satisfy current critical proof")


def assert_source_and_admin_fixtures() -> None:
    if source_probe_fixture(present=False, error="Permission denied") != "permission_denied":
        raise AssertionError("known unreadable source must be permission_denied")
    if source_probe_fixture(present=False, error="No such file") != "missing":
        raise AssertionError("known absent optional source must be missing/expected-empty eligible")
    if source_probe_fixture(present=True, admin_text_valid=False) != "malformed":
        raise AssertionError("malformed readable Admin.ini must be explicit")
    if source_probe_fixture(present=False, error="device unavailable") != "unavailable":
        raise AssertionError("unknown open failure must remain unavailable")

    misplaced_bans, misplaced_valid = parse_bans_fixture("[Moderators]\nBannedPlayer=123456789\n")
    if misplaced_valid or misplaced_bans:
        raise AssertionError("BannedPlayer under Moderators must fail malformed and never parse as a ban")
    commented_bans, commented_valid = parse_bans_fixture("[BannedPlayers]\n; BannedPlayer=123456789\n# BannedPlayer=987654321\n")
    if not commented_valid or commented_bans:
        raise AssertionError("commented BannedPlayer lines must not become active bans")
    valid_bans, valid_layout = parse_bans_fixture("[BannedPlayers]\nBannedPlayer=123456789\n")
    if not valid_layout or valid_bans != {"123456789"}:
        raise AssertionError("valid BannedPlayers layout did not parse")
    suffix_bans, suffix_valid = parse_bans_fixture("[BannedPlayers]\nBannedPlayer=123abc\n")
    if suffix_valid or suffix_bans:
        raise AssertionError("numeric-prefix IDs with suffix text must fail malformed, not truncate")
    duplicate_bans, duplicate_valid = parse_bans_fixture("[BannedPlayers]\nBannedPlayer=123\n[BannedPlayers]\nBannedPlayer=456\n")
    if duplicate_valid:
        raise AssertionError("duplicate BannedPlayers sections must fail malformed")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run offline RandomDayGuard public-pipeline fixtures.")
    parser.add_argument(
        "--lua-command",
        type=Path,
        help="explicit Lua interpreter for local validation when it is not discoverable on PATH",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    lua_interpreter = find_lua_interpreter(args.lua_command)
    lua_checker = assert_lua_syntax_if_available(lua_interpreter)
    lua_runtime = assert_lua_runtime_fixture_if_available(lua_interpreter)
    lua_loader_integration = assert_lua_loader_integration_fixture_if_available(lua_interpreter)
    lua_enforcement_runtime = assert_lua_enforcement_runtime_fixture_if_available(lua_interpreter)
    assert_static_contract()
    assert_enforcement_fixtures()
    assert_route_fixtures()
    assert_coverage_contract_fixtures()
    assert_inventory_fixtures()
    assert_identity_translation_fixtures()
    assert_case_and_output_fixtures()
    assert_source_and_admin_fixtures()
    print(
        "PUBLIC PIPELINE FIXTURES PASSED "
        f"(lua_checker={lua_checker}, lua_runtime={lua_runtime}, "
        f"lua_loader_integration={lua_loader_integration}, "
        f"lua_enforcement_runtime={lua_enforcement_runtime})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
