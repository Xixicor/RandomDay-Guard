from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
UPPER_MAIN = ROOT / "RandomDayGuard" / "Scripts" / "main.lua"


def load_validator():
    path = ROOT / "tools" / "validate_repo.py"
    spec = importlib.util.spec_from_file_location("scheduler_offset_validator", path)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load tools/validate_repo.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def function_block(source: str, name: str, next_name: str) -> str:
    start = f"local function {name}"
    end = f"local function {next_name}"
    if start not in source or end not in source:
        raise AssertionError(f"missing function boundary: {name} -> {next_name}")
    return source.split(start, 1)[1].split(end, 1)[0]


class SchedulerOffsetRegressionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.source = UPPER_MAIN.read_text(encoding="utf-8")

    def test_canonical_loader_has_no_case_variant(self) -> None:
        self.assertTrue(UPPER_MAIN.is_file())
        files = {path.relative_to(ROOT).as_posix() for path in ROOT.rglob("*") if path.is_file()}
        self.assertNotIn("RandomDayGuard/scripts/main.lua", files)

    def test_main_declares_public_contract_and_failure_behavior(self) -> None:
        opening = "\n".join(self.source.splitlines()[:20])
        self.assertIn(
            "-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog",
            opening,
        )
        self.assertIn("-- Public contract:", opening)
        self.assertIn("-- Failure behavior:", opening)

    def test_platform_specific_path_fallbacks_are_windows_only(self) -> None:
        self.assertEqual(self.source.count("if not f and IS_WINDOWS then"), 2)
        self.assertEqual(self.source.count("if not rok and IS_WINDOWS then"), 1)
        self.assertEqual(self.source.count("if not ok_rename and IS_WINDOWS then"), 2)
        self.assertEqual(self.source.count("if not moved_old and IS_WINDOWS then"), 1)
        self.assertEqual(self.source.count("if not restored and IS_WINDOWS then"), 1)

    def test_offsets_and_registry_commit_only_after_event_application(self) -> None:
        update_registry = function_block(
            self.source, "update_log_registry", "write_poll_status"
        )
        tail = function_block(self.source, "tail_logs", "startup_scan")
        poll = function_block(self.source, "poll_once", "safe_poll_once")

        self.assertIn("persist_registry", update_registry)
        self.assertIn("update_log_registry(false)", tail)
        self.assertNotIn("write_offsets(", tail)
        self.assertNotIn(
            'write_json(runtime_path("runtime/log_registry.json")', tail
        )
        self.assertIn("pending_recent_event_keys", tail)
        self.assertIn("offsets=offsets", tail)

        applied = poll.index("for _,ev in ipairs(evs) do apply_event(ev) end")
        registry_commit = poll.index(
            'write_json(runtime_path("runtime/log_registry.json"), state.log_registry)'
        )
        offset_commit = poll.index("write_offsets(tail_meta.offsets)")
        self.assertLess(applied, registry_commit)
        self.assertLess(registry_commit, offset_commit)
        self.assertIn("registry_ok", poll)
        self.assertIn("offsets_ok", poll)
        self.assertIn("offset_commit_failed_after_events_applied", poll)
        self.assertIn("offset_commit_failed", poll)
        self.assertIn("if tail_meta.offset_commit_failed ~= true then", poll)

    def test_scheduler_stays_alive_and_runs_reports_between_polls(self) -> None:
        safe_poll = function_block(self.source, "safe_poll_once", "run_public_report_opportunity")
        schedule = function_block(self.source, "schedule_next_poll", "stop_poll_loop")

        self.assertNotIn("refresh_public_pipeline(", safe_poll)
        self.assertIn('while state.scheduler_status == "running" do', schedule)
        self.assertNotIn("schedule_next_poll()", schedule)
        poll_at = schedule.index('safe_poll_once("loop")')
        report_at = schedule.index(
            'run_public_report_opportunity("poll_owner_between_polls")'
        )
        sleep_at = schedule.index("scheduler_sleep_ms(interval)")
        self.assertLess(poll_at, report_at)
        self.assertLess(report_at, sleep_at)
        self.assertIn("return true", schedule)

    def test_master_disable_stops_before_saved_discovery_and_scheduler_registration(self) -> None:
        load_config = function_block(self.source, "load_config", "recursive_listing_commands")
        start = function_block(self.source, "start", "poll_once")
        safe_poll = function_block(
            self.source, "safe_poll_once", "run_public_report_opportunity"
        )

        self.assertIn("enabled=true", load_config)
        disabled_at = start.index("if state.config.enabled == false then")
        saved_discovery_at = start.index("state.saved_root = find_saved_root()")
        scheduler_at = start.index("start_poll_loop()")
        self.assertLess(disabled_at, saved_discovery_at)
        self.assertLess(disabled_at, scheduler_at)
        disabled_branch = start[disabled_at:saved_discovery_at]
        for marker in (
            'state.scheduler_status = "disabled"',
            'state.poll_stage = "disabled"',
            'phase="disabled"',
            'poll_in_flight=false',
            "return false",
        ):
            self.assertIn(marker, disabled_branch)
        self.assertTrue(
            safe_poll.lstrip().startswith("(reason)\n    if state.disabled then"),
            "manual/scheduled poll entry must stay inert when Guard is disabled",
        )

    def test_safe_poll_persists_terminal_completion_before_report_opportunity(self) -> None:
        safe_poll = function_block(
            self.source, "safe_poll_once", "run_public_report_opportunity"
        )
        completed_at = safe_poll.index(
            "state.poll_completed_count = (state.poll_completed_count or 0) + 1"
        )
        terminal_write_at = safe_poll.index("write_poll_status({", completed_at)
        report_pending_at = safe_poll.index(
            "state.report_refresh_pending = true", terminal_write_at
        )
        self.assertLess(completed_at, terminal_write_at)
        self.assertLess(terminal_write_at, report_pending_at)
        self.assertIn("poll_in_flight=false", safe_poll[terminal_write_at:])
        self.assertIn("poll_completed_count=state.poll_completed_count", safe_poll[terminal_write_at:])
        self.assertIn("last_poll_completed_ts=state.last_poll_completed_ts", safe_poll[terminal_write_at:])
        self.assertIn('poll_stage=state.current_poll_error and "error" or state.poll_stage', safe_poll[terminal_write_at:])

    def test_validator_rejects_old_scheduler_and_offset_models(self) -> None:
        validator = load_validator()
        errors: list[str] = []
        validator.validate_scheduler_offset_contract(
            """
local function write_offsets(offsets)
    write_tsv("runtime/log_offsets.tsv", {}, {})
end
local function update_log_registry()
    write_json(runtime_path("runtime/log_registry.json"), state.log_registry)
end
local function write_poll_status()
end
local function tail_logs()
    update_log_registry()
    write_offsets(offsets)
    write_json(runtime_path("runtime/log_registry.json"), state.log_registry)
    return events, seen, {offsets=offsets}
end
local function startup_scan()
end
local function poll_once()
    local evs = tail_logs()
    for _,ev in ipairs(evs) do apply_event(ev) end
end
local function safe_poll_once()
    refresh_public_pipeline("poll", true)
end
local function run_public_report_opportunity()
end
local function schedule_next_poll()
    LoopAsync(interval, function()
        safe_poll_once("loop")
        schedule_next_poll()
        return false
    end)
end
local function stop_poll_loop()
end
""",
            errors,
        )
        self.assertIn(
            "LoopAsync poll scheduler is not the live-proven stay-alive owner model",
            errors,
        )
        self.assertIn(
            "LoopAsync poll callback recursively requeues schedule_next_poll",
            errors,
        )
        self.assertIn(
            "tail_logs persists offsets or registry before parsed events are applied",
            errors,
        )
        self.assertIn(
            "safe_poll_once runs the public report pipeline inline",
            errors,
        )


if __name__ == "__main__":
    unittest.main()
